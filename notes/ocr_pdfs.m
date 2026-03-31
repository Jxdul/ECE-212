#import <Foundation/Foundation.h>
#import <PDFKit/PDFKit.h>
#import <Vision/Vision.h>
#import <AppKit/AppKit.h>
#import <CoreGraphics/CoreGraphics.h>
#import <ImageIO/ImageIO.h>

static NSString *PageImageName(NSUInteger pageNumber) {
    return [NSString stringWithFormat:@"page-%04lu.png", (unsigned long)pageNumber];
}

static NSString *PageTextName(NSUInteger pageNumber) {
    return [NSString stringWithFormat:@"page-%04lu.txt", (unsigned long)pageNumber];
}

static BOOL EnsureDirectoryExists(NSURL *directoryURL, NSError **error) {
    return [[NSFileManager defaultManager] createDirectoryAtURL:directoryURL
                                   withIntermediateDirectories:YES
                                                    attributes:nil
                                                         error:error];
}

static BOOL FlipSavedPNGHorizontally(NSURL *imageURL, NSError **error) {
    NSString *temporaryPath = [imageURL.path stringByAppendingString:@".flipped.png"];
    NSURL *temporaryURL = [NSURL fileURLWithPath:temporaryPath];

    NSTask *task = [[NSTask alloc] init];
    task.launchPath = @"/usr/bin/sips";
    task.arguments = @[@"--flip", @"horizontal", imageURL.path, @"--out", temporaryURL.path];

    NSPipe *outputPipe = [NSPipe pipe];
    task.standardOutput = outputPipe;
    task.standardError = outputPipe;

    @try {
        [task launch];
        [task waitUntilExit];
    } @catch (NSException *exception) {
        if (error != NULL) {
            *error = [NSError errorWithDomain:@"OCRPDFs"
                                         code:14
                                     userInfo:@{NSLocalizedDescriptionKey:
                                                    [NSString stringWithFormat:@"Failed to launch sips: %@", exception.reason]}];
        }
        return NO;
    }

    if (task.terminationStatus != 0) {
        NSData *outputData = [[outputPipe fileHandleForReading] readDataToEndOfFile];
        NSString *output = [[NSString alloc] initWithData:outputData encoding:NSUTF8StringEncoding] ?: @"Unknown sips error.";
        if (error != NULL) {
            *error = [NSError errorWithDomain:@"OCRPDFs"
                                         code:15
                                     userInfo:@{NSLocalizedDescriptionKey: output}];
        }
        return NO;
    }

    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtURL:imageURL error:nil];
    return [fileManager moveItemAtURL:temporaryURL toURL:imageURL error:error];
}

static CGImageRef LoadImageAtURL(NSURL *imageURL, NSError **error) {
    CGImageSourceRef source = CGImageSourceCreateWithURL((__bridge CFURLRef)imageURL, NULL);
    if (source == NULL) {
        if (error != NULL) {
            *error = [NSError errorWithDomain:@"OCRPDFs"
                                         code:16
                                     userInfo:@{NSLocalizedDescriptionKey: @"Unable to read saved PNG for OCR."}];
        }
        return NULL;
    }

    CGImageRef image = CGImageSourceCreateImageAtIndex(source, 0, NULL);
    CFRelease(source);

    if (image == NULL && error != NULL) {
        *error = [NSError errorWithDomain:@"OCRPDFs"
                                     code:17
                                 userInfo:@{NSLocalizedDescriptionKey: @"Unable to decode saved PNG for OCR."}];
    }

    return image;
}

static CGImageRef CreatePageImage(PDFPage *page, CGFloat dpi, BOOL rotate180, NSError **error) {
    NSRect pageBounds = [page boundsForBox:kPDFDisplayBoxMediaBox];
    CGFloat scale = dpi / 72.0;
    size_t width = (size_t)ceil(pageBounds.size.width * scale);
    size_t height = (size_t)ceil(pageBounds.size.height * scale);

    if (width == 0 || height == 0) {
        if (error != NULL) {
            *error = [NSError errorWithDomain:@"OCRPDFs"
                                         code:10
                                     userInfo:@{NSLocalizedDescriptionKey: @"Page has invalid dimensions."}];
        }
        return NULL;
    }

    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL, width, height, 8, 0, colorSpace, kCGImageAlphaPremultipliedLast);
    CGColorSpaceRelease(colorSpace);

    if (context == NULL) {
        if (error != NULL) {
            *error = [NSError errorWithDomain:@"OCRPDFs"
                                         code:11
                                     userInfo:@{NSLocalizedDescriptionKey: @"Unable to create bitmap context."}];
        }
        return NULL;
    }

    CGContextSetRGBFillColor(context, 1.0, 1.0, 1.0, 1.0);
    CGContextFillRect(context, CGRectMake(0, 0, width, height));

    // Map PDF points into image pixels. Some of this note set is stored upside down,
    // so an optional alternate transform renders it upright without using embedded text.
    if (rotate180) {
        CGContextTranslateCTM(context, width, 0);
        CGContextScaleCTM(context, -scale, scale);
    } else {
        CGContextTranslateCTM(context, 0, height);
        CGContextScaleCTM(context, scale, -scale);
    }
    [page drawWithBox:kPDFDisplayBoxMediaBox toContext:context];

    CGImageRef image = CGBitmapContextCreateImage(context);
    CGContextRelease(context);

    if (image == NULL) {
        if (error != NULL) {
            *error = [NSError errorWithDomain:@"OCRPDFs"
                                         code:12
                                     userInfo:@{NSLocalizedDescriptionKey: @"Unable to render page image."}];
        }
        return NULL;
    }

    return image;
}

static BOOL WritePNG(CGImageRef image, NSURL *destinationURL, NSError **error) {
    NSBitmapImageRep *bitmap = [[NSBitmapImageRep alloc] initWithCGImage:image];
    NSData *pngData = [bitmap representationUsingType:NSBitmapImageFileTypePNG properties:@{}];
    if (pngData == nil) {
        if (error != NULL) {
            *error = [NSError errorWithDomain:@"OCRPDFs"
                                         code:13
                                     userInfo:@{NSLocalizedDescriptionKey: @"Unable to encode PNG image."}];
        }
        return NO;
    }
    return [pngData writeToURL:destinationURL options:NSDataWritingAtomic error:error];
}

static NSString *RecognizeTextFromImage(CGImageRef image, NSError **error) {
    VNRecognizeTextRequest *request = [[VNRecognizeTextRequest alloc] init];
    request.recognitionLevel = VNRequestTextRecognitionLevelAccurate;
    request.usesLanguageCorrection = YES;

    if (@available(macOS 13.0, *)) {
        request.automaticallyDetectsLanguage = YES;
    } else {
        request.recognitionLanguages = @[@"en-US"];
    }

    VNImageRequestHandler *handler = [[VNImageRequestHandler alloc] initWithCGImage:image options:@{}];
    if (![handler performRequests:@[request] error:error]) {
        return nil;
    }

    NSArray<VNRecognizedTextObservation *> *observations = request.results ?: @[];
    NSArray<VNRecognizedTextObservation *> *sortedObservations =
        [observations sortedArrayUsingComparator:^NSComparisonResult(VNRecognizedTextObservation *left,
                                                                     VNRecognizedTextObservation *right) {
            CGFloat rowTolerance = 0.015;
            CGFloat yDelta = left.boundingBox.origin.y - right.boundingBox.origin.y;
            if (fabs(yDelta) > rowTolerance) {
                return yDelta > 0 ? NSOrderedAscending : NSOrderedDescending;
            }
            if (left.boundingBox.origin.x < right.boundingBox.origin.x) {
                return NSOrderedAscending;
            }
            if (left.boundingBox.origin.x > right.boundingBox.origin.x) {
                return NSOrderedDescending;
            }
            return NSOrderedSame;
        }];

    NSMutableArray<NSString *> *lines = [NSMutableArray arrayWithCapacity:sortedObservations.count];
    for (VNRecognizedTextObservation *observation in sortedObservations) {
        VNRecognizedText *candidate = [[observation topCandidates:1] firstObject];
        if (candidate != nil && candidate.string.length > 0) {
            [lines addObject:candidate.string];
        }
    }

    return [lines componentsJoinedByString:@"\n"];
}

static BOOL OCRPDFAtURL(NSURL *pdfURL, NSURL *outputRootURL, CGFloat dpi, BOOL rotate180, NSError **error) {
    PDFDocument *document = [[PDFDocument alloc] initWithURL:pdfURL];
    if (document == nil) {
        if (error != NULL) {
            *error = [NSError errorWithDomain:@"OCRPDFs"
                                         code:20
                                     userInfo:@{NSLocalizedDescriptionKey:
                                                    [NSString stringWithFormat:@"Unable to open PDF: %@", pdfURL.path]}];
        }
        return NO;
    }

    NSString *baseName = pdfURL.lastPathComponent.stringByDeletingPathExtension;
    NSURL *pdfOutputURL = [outputRootURL URLByAppendingPathComponent:baseName isDirectory:YES];
    NSURL *pagesURL = [pdfOutputURL URLByAppendingPathComponent:@"pages" isDirectory:YES];
    if (!EnsureDirectoryExists(pagesURL, error)) {
        return NO;
    }

    NSMutableString *combinedText = [NSMutableString string];
    NSUInteger pageCount = (NSUInteger)document.pageCount;

    for (NSUInteger index = 0; index < pageCount; index++) {
        @autoreleasepool {
            PDFPage *page = [document pageAtIndex:index];
            if (page == nil) {
                if (error != NULL) {
                    *error = [NSError errorWithDomain:@"OCRPDFs"
                                                 code:21
                                             userInfo:@{NSLocalizedDescriptionKey:
                                                            [NSString stringWithFormat:@"Missing page %lu in %@.",
                                                                                       (unsigned long)(index + 1),
                                                                                       pdfURL.lastPathComponent]}];
                }
                return NO;
            }

            NSError *pageError = nil;
            CGImageRef image = CreatePageImage(page, dpi, rotate180, &pageError);
            if (image == NULL) {
                if (error != NULL) {
                    *error = pageError;
                }
                return NO;
            }

            NSUInteger pageNumber = index + 1;
            NSURL *imageURL = [pagesURL URLByAppendingPathComponent:PageImageName(pageNumber)];
            if (!WritePNG(image, imageURL, &pageError)) {
                CGImageRelease(image);
                if (error != NULL) {
                    *error = pageError;
                }
                return NO;
            }

            CGImageRelease(image);

            if (rotate180 && !FlipSavedPNGHorizontally(imageURL, &pageError)) {
                if (error != NULL) {
                    *error = pageError;
                }
                return NO;
            }

            CGImageRef ocrImage = LoadImageAtURL(imageURL, &pageError);
            if (ocrImage == NULL) {
                if (error != NULL) {
                    *error = pageError;
                }
                return NO;
            }

            NSString *pageText = RecognizeTextFromImage(ocrImage, &pageError);
            CGImageRelease(ocrImage);

            if (pageText == nil) {
                if (error != NULL) {
                    *error = pageError;
                }
                return NO;
            }

            NSURL *pageTextURL = [pagesURL URLByAppendingPathComponent:PageTextName(pageNumber)];
            if (![pageText writeToURL:pageTextURL atomically:YES encoding:NSUTF8StringEncoding error:&pageError]) {
                if (error != NULL) {
                    *error = pageError;
                }
                return NO;
            }

            [combinedText appendFormat:@"===== Page %lu =====\n", (unsigned long)pageNumber];
            [combinedText appendString:pageText];
            [combinedText appendString:@"\n\n"];

            NSLog(@"OCR %@ page %lu/%lu", pdfURL.lastPathComponent, (unsigned long)pageNumber, (unsigned long)pageCount);
        }
    }

    NSURL *combinedTextURL = [pdfOutputURL URLByAppendingPathComponent:[NSString stringWithFormat:@"%@.ocr.txt", baseName]];
    if (![combinedText writeToURL:combinedTextURL atomically:YES encoding:NSUTF8StringEncoding error:error]) {
        return NO;
    }

    NSDictionary *manifest = @{
        @"source_pdf": pdfURL.path,
        @"page_count": @(pageCount),
        @"dpi": @(dpi),
        @"rotate_180": @(rotate180),
        @"combined_text": combinedTextURL.path,
        @"pages_directory": pagesURL.path
    };

    NSData *manifestData = [NSJSONSerialization dataWithJSONObject:manifest options:NSJSONWritingPrettyPrinted error:error];
    if (manifestData == nil) {
        return NO;
    }

    NSURL *manifestURL = [pdfOutputURL URLByAppendingPathComponent:@"manifest.json"];
    if (![manifestData writeToURL:manifestURL options:NSDataWritingAtomic error:error]) {
        return NO;
    }

    return YES;
}

int main(int argc, const char *argv[]) {
    @autoreleasepool {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSMutableArray<NSURL *> *pdfURLs = [NSMutableArray array];
        BOOL rotate180 = NO;

        if (argc > 1) {
            for (int i = 1; i < argc; i++) {
                NSString *argument = [NSString stringWithUTF8String:argv[i]];
                if ([argument isEqualToString:@"--rotate-180"]) {
                    rotate180 = YES;
                    continue;
                }
                [pdfURLs addObject:[NSURL fileURLWithPath:argument]];
            }
        } else {
            NSURL *cwd = [NSURL fileURLWithPath:fileManager.currentDirectoryPath isDirectory:YES];
            NSArray<NSURL *> *items = [fileManager contentsOfDirectoryAtURL:cwd
                                                 includingPropertiesForKeys:nil
                                                                    options:NSDirectoryEnumerationSkipsHiddenFiles
                                                                      error:nil];
            for (NSURL *itemURL in items) {
                if ([[itemURL.pathExtension lowercaseString] isEqualToString:@"pdf"]) {
                    [pdfURLs addObject:itemURL];
                }
            }
            [pdfURLs sortUsingComparator:^NSComparisonResult(NSURL *left, NSURL *right) {
                return [left.lastPathComponent compare:right.lastPathComponent];
            }];
        }

        if (pdfURLs.count == 0) {
            fprintf(stderr, "No PDF files found.\n");
            return 1;
        }

        NSURL *outputRootURL = [NSURL fileURLWithPath:[fileManager.currentDirectoryPath stringByAppendingPathComponent:@"ocr-output"] isDirectory:YES];
        NSError *error = nil;
        if (!EnsureDirectoryExists(outputRootURL, &error)) {
            fprintf(stderr, "Failed creating output directory: %s\n", error.localizedDescription.UTF8String);
            return 1;
        }

        CGFloat dpi = 220.0;
        BOOL hadFailure = NO;
        for (NSURL *pdfURL in pdfURLs) {
            NSError *pdfError = nil;
            NSLog(@"Starting OCR for %@", pdfURL.lastPathComponent);
            if (!OCRPDFAtURL(pdfURL, outputRootURL, dpi, rotate180, &pdfError)) {
                hadFailure = YES;
                fprintf(stderr, "Failed OCR for %s: %s\n", pdfURL.lastPathComponent.UTF8String, pdfError.localizedDescription.UTF8String);
            }
        }

        return hadFailure ? 2 : 0;
    }
}
