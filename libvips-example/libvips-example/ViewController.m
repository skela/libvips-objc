//
//  ViewController.m
//  libvips-example
//
//  Created by Aleksander Slater on 23/04/2015.
//  Copyright (c) 2015 Davincium. All rights reserved.
//

#import "ViewController.h"

#include <stdio.h>
#include <vips/vips.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)generateTilesVIPSFromOriginal:(NSString*)orig
{
    const char *filename = [orig fileSystemRepresentation];
    const char *testname = [@"/Users/skela/Desktop/test.png" fileSystemRepresentation];

    VipsImage *global;
    VipsImage **t;

    global = vips_image_new();
    t = (VipsImage **) vips_object_local_array( VIPS_OBJECT( global ), 5 );

    if( !(t[0] = vips_image_new_from_file( filename, NULL )) )
        vips_error_exit( "unable to read %s", filename );

    t[1] = vips_image_new_matrixv( 3, 3,
                                  -1.0, -1.0, -1.0,
                                  -1.0, 16.0, -1.0,
                                  -1.0, -1.0, -1.0 );
    vips_image_set_double( t[1], "scale", 8 );

    if( vips_crop( t[0], &t[2], 100, 100, t[0]->Xsize - 200, t[0]->Ysize - 200, NULL ) ||
       vips_similarity( t[2], &t[3], "scale", 0.9, NULL ) ||
       vips_conv( t[3], &t[4], t[1], NULL ) ||
       vips_image_write_to_file( t[4], testname, NULL ) )
        vips_error_exit( "unable to process %s", testname );

    g_object_unref( global );

}

@end
