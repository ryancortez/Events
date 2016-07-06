//
//  DatePickerCollectionViewLayout.swift
//  Shifts
//
//  Created by Ryan on 12/10/14.
//  Copyright (c) 2014 Full Screen Ahead. All rights reserved.
//

import UIKit

class DatePickerCollectionViewLayout: UICollectionViewLayout {

// #1
//    - (instancetype)init
//    {
//        self = [super init];
//        if (self) {
//            [self commonInitializer];
//        }
//        return self;
//    }
//    
//    - (instancetype)initWithCoder:(NSCoder *)aDecoder
//    {
//    self = [super initWithCoder:aDecoder];
//    if (self) {
//    [self commonInitializer];
//    }
//    return self;
//    }
//    
//    - (void)commonInitializer
//    {
//    self.minimumLineSpacing = [self selfMinimumLineSpacing];
//    self.minimumInteritemSpacing = [self selfMinimumInteritemSpacing];
//    }
//    
//    #pragma mark - Atrributes of the Layout
//    
//    - (CGSize)selfHeaderReferenceSize
//    {
//    CGFloat selfHeaderReferenceWidth = CGRectGetWidth(self.collectionView.frame);
//    CGFloat selfHeaderReferenceHeight = 64.0f;
//    
//    return (CGSize){ selfHeaderReferenceWidth, selfHeaderReferenceHeight };
//    }
//    
//    - (CGSize)selfItemSize
//    {
//    NSUInteger numberOfItemsInTheSameRow = 7;
//    CGFloat totalInteritemSpacing = [self minimumInteritemSpacing] * (numberOfItemsInTheSameRow - 1);
//    
//    CGFloat selfItemWidth = (CGRectGetWidth(self.collectionView.frame) - totalInteritemSpacing) / numberOfItemsInTheSameRow;
//    selfItemWidth = floor(selfItemWidth * 1000) / 1000;
//    CGFloat selfItemHeight = 70.0f;
//    
//    return (CGSize){ selfItemWidth, selfItemHeight };
//    }
//    
//    - (CGFloat)selfMinimumLineSpacing
//    {
//    return 2.0f;
//    }
//    
//    - (CGFloat)selfMinimumInteritemSpacing
//    {
//    return 2.0f;
//    }
   
}
