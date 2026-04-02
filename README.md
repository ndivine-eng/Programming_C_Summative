#  Programming C Summative Projects

##  Demo Video
Watch the full demo here:
https://www.loom.com/share/ae037e4eb61a469cbfb045c0d85ba923

---

##  Overview
This repository contains five C programming projects designed to demonstrate core programming concepts applied to real-world problems. The projects cover:

- Dynamic memory allocation  
- Data structures (structs)  
- File handling and persistence  
- Function pointers and callbacks  
- Multi-threading and concurrency  
- Embedded system simulation  
- Linux scripting and automation  

---

##  Project 3 — Academic Records Analyzer

### Description
This project is a complete **student management and academic analysis system** written in C. It allows users to store, manage, and analyze student performance data dynamically.

### Key Features
- Add, update, delete, and display student records  
- Each student includes ID, name, course, age, grades, and GPA  
- GPA is automatically calculated from grades  
- Search functionality (by ID and name)  
- Sorting (by GPA, name, and ID)  
- Analytical reports:
  - Average GPA  
  - Highest and lowest GPA  
  - Median GPA  
  - Top N students  
  - Best student per course  
  - Course average GPA  
- File persistence using `records.txt`  
- Input validation (duplicate IDs, valid grade ranges)  

### Concepts Demonstrated
- Dynamic memory (`malloc`, `realloc`, `free`)  
- Structures and data organization  
- File handling  
- Searching and sorting algorithms  
- Data validation and user input handling  

---

##  Project 4 — Data Analysis Toolkit

### Description
This project is a **numerical data processing system** that allows users to analyze datasets dynamically using function pointers and callback functions.

### Key Features
- Create and manage a dataset dynamically  
- Compute:
  - Sum and average  
  - Minimum and maximum  
- Apply filtering (e.g., values above a threshold)  
- Apply transformations (e.g., scaling values)  
- Sort dataset (ascending or descending)  
- Search for specific values  
- Save and load dataset from file (`dataset.txt`)  

### Concepts Demonstrated
- Function pointers for menu actions  
- Callback functions for flexible processing  
- Dynamic memory allocation  
- Modular and reusable design  
- File handling and persistence  

---

##  Project 1 — Smart Traffic Light Controller

### Description
This project simulates a **smart traffic light system** using Arduino logic. It manages two intersections and adjusts traffic flow based on vehicle detection.

### Key Features
- LED-based traffic lights (Red, Yellow, Green)  
- Push-button vehicle detection  
- Dynamic timing adjustment based on traffic volume  
- Non-blocking control using `millis()`  
- Serial interface for monitoring and manual override  
- PCB design using EasyEDA  

### Concepts Demonstrated
- Embedded systems programming  
- Real-time control logic  
- Non-blocking execution  
- Hardware simulation and PCB design  

---

##  Project 2 — Linux Server Monitoring Script

### Description
This project is a **Linux shell script** used to monitor system performance and automate alerts.

### Key Features
- Monitors:
  - CPU usage  
  - Memory usage  
  - Disk usage  
  - Running processes  
- Generates alerts when thresholds are exceeded  
- Logs system activity with timestamps  
- Menu-driven interface  
- Start/stop monitoring functionality  

### Concepts Demonstrated
- Shell scripting  
- System monitoring  
- Automation  
- Logging and alert systems  

---

##  Project 5 — Multi-threaded Web Scraper

### Description
This project is a **multi-threaded web scraper** that downloads multiple web pages concurrently using POSIX threads.

### Key Features
- Reads URLs from a file (`urls.txt`)  
- Creates one thread per URL  
- Downloads web content in parallel  
- Saves each page to a separate file  
- Handles errors for unreachable URLs  

### Concepts Demonstrated
- Multi-threading (POSIX threads)  
- Parallel execution  
- File output handling  
- Basic error handling  

---

##  Conclusion

These projects collectively demonstrate the ability to apply C programming concepts to solve practical problems across different domains, including:

- Data management systems  
- Numerical analysis  
- Embedded system simulation  
- System automation  
- Concurrent processing  

---

##  Requirements

- GCC Compiler (Linux/WSL)  
- Arduino IDE or Tinkercad (Project 1)  
- Linux environment (Project 2)  

---

##  Project Structure

```
project1/
project2/
project3/
project4/
project5/
```

---


