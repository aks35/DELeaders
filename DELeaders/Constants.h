/**
 Constants class, look below at the #define lines for descriptions and available constants to be modified
 
 Matthew Tse
 
 */


/*
 * Copyright 2010-2012 Amazon.com, Inc. or its affiliates. All Rights Reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License").
 * You may not use this file except in compliance with the License.
 * A copy of the License is located at
 *
 *  http://aws.amazon.com/apache2.0
 *
 * or in the "license" file accompanying this file. This file is distributed
 * on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either
 * express or implied. See the License for the specific language governing
 * permissions and limitations under the License.
 */

#import <Foundation/Foundation.h>

/**
 * This is the the DNS domain name of the endpoint your Token Vending
 * Machine is running.  (For example, if your TVM is running at
 * http://mytvm.elasticbeanstalk.com this parameter should be set to
 * mytvm.elasticbeanstalk.com.)
 */
#define TOKEN_VENDING_MACHINE_URL    @"http://mytvmdel.elasticbeanstalk.com/"

/**
 * This indiciates whether or not the TVM is supports SSL connections.
 */
#define USE_SSL                      NO


#define CREDENTIALS_ALERT_MESSAGE    @"Please update the Constants.h file with your credentials or Token Vending Machine URL."
//Access_key_id should not be used since we are using a TVM vending machine
#define ACCESS_KEY_ID                @"USED-ONLY-FOR-TESTING"  // Leave this value as is.
//secret_key should not be used since we are using a TVM vending machine
#define SECRET_KEY                   @"USED-ONLY-FOR-TESTING"  // Leave this value as is.
//suffix appended to the end of each compressed image to differentiate it from the original sized image
#define COMPRESSED_SUFFIX            @"_compressed"
//S3 bucket name for the original uncompressed uploaded images
#define ORIGINAL_IMAGE_BUCKET_NAME   @"delpictures"
//S3 bucket name for the compressed uploaded images
#define COMPRESSED_IMAGE_BUCKET_NAME @"delpicturescompressed"
//standard width for compressed image
#define COMPRESSED_IMAGE_WIDTH       300
//standard height for compressed image
#define COMPRESSED_IMAGE_DISPLAY_WIDTH 150


@interface Constants:NSObject {
}

+(UIAlertView *)credentialsAlert;
+(UIAlertView *)errorAlert:(NSString *)message;
+(UIAlertView *)expiredCredentialsAlert;

@end
