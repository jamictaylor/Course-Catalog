//
//  ContentView.swift
//  Course Catalog
//
//  Created by Jami Taylor on 5/30/22.
//

import SwiftUI
  
import Foundation

// sort method on course name
struct ChecklistItem: Comparable{
    static func < (lhs: ChecklistItem, rhs: ChecklistItem) -> Bool {
            return lhs.name < rhs.name
        }
        
        static func == (lhs: ChecklistItem, rhs: ChecklistItem) -> Bool {
            return lhs.name == rhs.name
        }
 // variables for struct
 var name: String
 var isChecked: Bool = false
 var shortDescription: String
   
    // init function to get key and short description from 
    init(key: String, values: [String: String])
   {
       name = key
       self.shortDescription = values["ShortDescription"]!
   }
}

class ChecklistItems: ObservableObject{
    @Published var items:[ChecklistItem] //watch for changes
    
    init(items: [ChecklistItem])
    {
        self.items = items
    }
}

struct ContentView: View
{
    //2nd step. init function
    init()
    {
        //load courses function, pulls data out of plist
        loadCSCourses()
        
        // convertedData creates a struct
        let convertedData = ContentView.convertDataToStructs(data: coursesDict)
        
        // CheckListItems is a list that holds a struct for each list item
        let list = ChecklistItems(items: convertedData)
        
        
        self._courseList = StateObject(wrappedValue: list)
        
    }
    
    static private func convertDataToStructs(data: [String : [String : String]])->[ChecklistItem]
    {
        var items = [ChecklistItem]()
        
        for course in data {
            let item = ChecklistItem(key: course.key, values: course.value)
            
            items.append(item)
        }
        return items.sorted()
    }
    
    
    @StateObject private var courseList: ChecklistItems
    
 
    @State private var showOnlySelected: Bool = false
   
    var body: some View
    {
        VStack
        {
            Text("Course Catalog")
                .font(.headline)
                .padding()
                .accessibilityLabel("title")
        }
        
        List
            {
                ForEach(Array(courseList.items.enumerated()), id: \.1.name)
                { (index, course) in

                    if showOnlySelected
                    {
                        if course.isChecked == true
                        {
                        
                            HStack
                            {
                                Image(systemName: course.isChecked ? "checkmark.square" : "square")
                                    .resizable()
                                    .frame(width: 32.0, height: 32.0)
                                    .accessibilityLabel(course.isChecked ? "ischecked" : "notchecked")
                                /*
                                Image(systemName: "checkmark.square")
                                    .resizable()
                                    .frame(width: 32.0, height: 32.0)
                                    .accessibilityLabel("ischecked")
                                 */
                                    
                                VStack(alignment: .leading)
                                {
                                    Text(course.name)
                                        .font(.title3)
                                    Text(course.shortDescription)
                                        .font(.subheadline)
                                }
                            } .onTapGesture {
                                if course.isChecked == false
                                {
                                    courseList.items[index].isChecked = true
                                }
                                else
                                {
                                    courseList.items[index].isChecked = false
                                }
                            }
                        }
                    }
                    else
                    {
                        HStack
                        {
                            Image(systemName: course.isChecked ? "checkmark.square" : "square")
                                .resizable()
                                .frame(width: 32.0, height: 32.0)
                                .accessibilityLabel(course.isChecked ? "ischecked" : "notchecked")
                            /*
                            Image(systemName: "checkmark.square")
                                .resizable()
                                .frame(width: 32.0, height: 32.0)
                                .accessibilityLabel("ischecked")
                             */
                                
                            VStack(alignment: .leading)
                            {
                                Text(course.name)
                                    .font(.title3)
                                Text(course.shortDescription)
                                    .font(.subheadline)
                            }
                        } .onTapGesture {
                            if course.isChecked == false
                            {
                                courseList.items[index].isChecked = true
                            }
                            else
                            {
                                courseList.items[index].isChecked = false
                            }
                        }
                    }
                    
                   
                } // end for each
            } // end list
    
            HStack
            {
                Toggle("Show Only Selected Courses", isOn: $showOnlySelected)
                    .accessibilityLabel("showOnlySelectedCoursesSwitch")
            }.padding(10)
    
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
}
