//
//  ViewController.swift
//  Sorting
//
//  Created by Arun George on 12/6/17.
//  Copyright © 2017. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        var arrayToSort = [Int]()
       // arrayToSort = [1, 2, 3, 4, 5]
        arrayToSort = randomElements()
        print("Before")
        printElements(in: arrayToSort)
       // bubble(array: arrayToSort)
        //insertionSort(array: arrayToSort)
       // quickSort(array: arrayToSort)
       // testInsertionSort(a: &arrayToSort)
        //testQuickSort(array: &arrayToSort)
        mergeSort(array: &arrayToSort)
        print("after")
        printElements(in: arrayToSort)
        validateSorted(array: arrayToSort)
        let element = arrayToSort[8]
        let elementIndex = binarySearch(array: arrayToSort, element: 111)
        print("element found at Index: \(elementIndex)")
    }
    
    // MARK: - Merge Sort
    func mergeSort(array: inout [Int]) {
        // Divide the array into partitions and call merge.
        if array.count < 2 { return }   // break out from recursion.
        var leftArray = Array(array[0..<array.count / 2])
        var rightArray = Array(array[array.count / 2..<array.count])
        mergeSort(array: &leftArray)
        mergeSort(array: &rightArray)
        mergeInto(array: &array, leftArray: leftArray, rightArray: rightArray)
    }
    
    func mergeInto(array: inout [Int], leftArray: [Int], rightArray: [Int]) {
        var i = 0, j = 0, k = 0
        while i < leftArray.count && j < rightArray.count {
            if leftArray[i] <= rightArray[j] {
               array[k] = leftArray[i]
                i += 1
            } else {
                array[k] = rightArray[j]
                j += 1
            }
            k += 1
        }
        while i < leftArray.count {
            array[k] = leftArray[i]
            i += 1
            k += 1
        }
        while j < rightArray.count {
            array[k] = rightArray[j]
            j += 1
            k += 1
        }
    }
    
    // MARK: - Quick Sort
    func quickSort(array: [Int]) {
        var arrayToSort = array
        
        quickSort(array: &arrayToSort, start: 0, end: arrayToSort.count - 1)
        print("after")
        printElements(in: arrayToSort)
    }
    
    func quickSort( array: inout [Int], start: Int, end: Int) {
        if start < end {
            let p = partition(a: &array, start: start, end: end)
            quickSort(array: &array, start: start, end: p - 1)
            quickSort(array: &array, start: p + 1, end: end)
        }
    }
    
    func partition( a: inout [Int], start: Int, end: Int) -> Int {
        var pIndex = start
        let pivot = a[end]
        for i in start..<end {
            if a[i] <= pivot {
                a.swapAt(i, pIndex)
                pIndex+=1
            }
        }
        a.swapAt(pIndex, end)
        return pIndex
    }
    
    //MARK: - Sorts
    func insertionSort(array: [Int]) {
        var a = array
        print("Before")
        printElements(in: a)
        var jRepetition = 0
        print("total elements: \(a.count)")
        for i in 1..<a.count {
            var j = i
            jRepetition = 0
            while j > 0 && a[j-1] > a[j] {
                a.swapAt(j, j-1)
                j -= 1
                jRepetition += 1
            }
            print("jRepetition: \(jRepetition)")
        }
        printElements(in: a)
    }
    
    func bubble(array: [Int]) {
        var arrayToSort = array
        print("Before")
        printElements(in: arrayToSort)
        var didSwap = false
        var jRepetition = 0
        print("total elements: \(arrayToSort.count)")
        for i in 0..<arrayToSort.count {
            didSwap = false
            jRepetition = 0
            for j in 0..<arrayToSort.count-i-1 {
                jRepetition += 1
                if arrayToSort[j] > arrayToSort[j+1] {
                    arrayToSort.swapAt(j, j+1)
                    didSwap = true
                }
            }
            print("jRepetition: \(jRepetition)")
            if !didSwap { break }
        }
        print("\n After")
        printElements(in: arrayToSort)
    }
    
    //MARK: - Other Methods
    func binarySearch(array: [Int], element: Int) -> Int {
        print("searching element: \(element)")
        var start = 0, end = array.count - 1
        while start < end {
            //let mid = (start + end) / 2
            // Optimizing for large integer overflow in case of very large arrays.
            let mid = start / 2 + end / 2
            if array[mid] == element {
                return mid
            } else if element < array[mid] {
                end = mid - 1
            } else {
                start = mid + 1
            }
        }
        return -1
    }
    
    //MARK: - Other Methods
    func printElements(in array: [Int]) {
        for i in 0..<array.count {
            print("\(array[i])")
        }
    }
    
    func randomElements() -> [Int] {
        var array = [Int]()
        for _ in 1...10 {
            array.append(Int(arc4random_uniform(100)))
        }
        return array
    }
    
    func validateSorted(array: [Int]) {
        var valid = true
        for i in 0..<array.count-1 {
            if array[i] > array[i+1] {
                valid = false
                break
            }
        }
        if valid { print("correctly sorted array") } else {
            print("invalid sorting") }
    }
}

extension ViewController {
    func testInsertionSort(a: inout [Int]) {
        for i in 1..<a.count {
            var j = i
            while j > 0 && a[j-1] > a[j] {
                a.swapAt(j, j-1)
                j -= 1
            }
        }
    }
    
    func testQuickSort(array: inout [Int]) {
        testQsort(array: &array, start: 0, end: array.count-1)
    }
    
    func testQsort(array: inout [Int], start: Int, end: Int) {
        if start >= end { return }
        let p = partition(array: &array, min: start, max: end)
        testQsort(array: &array, start: 0, end: p - 1)
        testQsort(array: &array, start: p+1, end: end)
    }
    
    func partition(array: inout [Int], min: Int, max: Int) -> Int {
        let pivot = array[max]
        var pIndex = min
        var i = min
        while i < max {
            if array[i] < pivot {
                array.swapAt(pIndex, i)
                pIndex += 1
            }
            i += 1
        }
        array.swapAt(max, pIndex)
        return pIndex
    }
}
