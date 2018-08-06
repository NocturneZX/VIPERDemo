#### Objective
I manage to complete the project. It took me a full week for two things. One) This project was an introduction to the VIPER Architecture. I have heard about this architecture briefly back when I was in TurnToTech, but never had an opportunity. Two) There seemed to be new ways to parsing JSON using the Codable protocol. I will say that it beats the days of NSCoding where it was used to serialize JSON objects. String, Int, Array, Dictionary all conform to the protocol, hence the decision to make the change. Codable also allows new objects to be easily added if a JSON structure is updated.

#### Design
According to what I grasped on VIPER, the achievements were the key to the project. So I had to create, at least, five different classes with distinct roles. I think for every object made in an app, you'd have to have the 5 classes implemented, hence the reason this architecture is used for highly scaled applications. The Router class seems to be the only one that creates the module to couple the VIPER classes for the object.

#### Implementation
Implementation was time-consuming initially. I started with creating the classes manually, but it took a considerable amount of  time not only understanding the architecture, but applying it. I ended up installing an XCode module that create the VIPER classes for every object I felt needed a module. In this particular case, One. 

I made a couple of key mistakes in this app.  For one thing, I should have implemented the project in MVC, first. I dove straight into VIPER and I ended up being tangled in implementing each VIPER class whilst implementing the rest of the project such as Core Data and its respective model. While I find this excellent in understanding certain concepts, implementing the program first would have shifted the focus more unto understanding the architecture. Another was that, I humbly and shamfeully admit, I haven't worked in Core Data for a long time. My last Core Data Stack I made needed to be updated badly and I spent some time restructuring it. One of my projects in GitHub shows my old Obj-C Core Data stack. I'm still learning new things such as NSPersistentContainer, but I did not wish to to spread myself thin in learning the new things that comes with this project. It was a tough call in my end, but I thought that it was the right choice.

#### Criticism of the VIPER Architecture
I like this architecture. It provides a sense of order that MVC never had. The main problem with MVC is that it took care of everything. Business model, presenting the view, setting up multiple delegates to populate the view; It never was meant to be sustainable. VIPER introduces a rigidness that is needed for large projects because I have seen large projects with my experience. It is not pretty. 

Another thing about VIPER is that it is very protcol-oriented. For every VIPER classes, I had to create, at least, one protocol in order to couple other respective VIPER classes. I never used so many protocols in my life. Every change I needed to make in these classes, I need to update its respective protocols. So much so, I need to create a class that houses these protocol. It reminded me so much of method swizzling where you would change the implementation of a function, prime example would be the presenter's viewDidLoad and the standard viewDidLoad. 

One standard week isn't enough to familiarize with VIPER, but I did learn a lot.

#### Resources Used
[Building iOS App With VIPER Architecture](https://blog.mindorks.com/building-ios-app-with-viper-architecture-8109acc72227)  
