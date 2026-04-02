#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MAX_NAME 100
#define MAX_COURSE 100
#define MAX_SUBJECTS 5

typedef struct {
    int id;
    char name[MAX_NAME];
    char course[MAX_COURSE];
    int age;
    float grades[MAX_SUBJECTS];
    float gpa;
} Student;

Student *students = NULL;
int count = 0;

float calculateGPA(float grades[], int size) {
    float sum = 0;
    for (int i = 0; i < size; i++) {
        sum += grades[i];
    }
    return sum / size;
}

int findStudentById(int id) {
    for (int i = 0; i < count; i++) {
        if (students[i].id == id) {
            return i;
        }
    }
    return -1;
}

void addStudent() {
    Student s;

    printf("Enter student ID: ");
    scanf("%d", &s.id);
    getchar();

    if (findStudentById(s.id) != -1) {
        printf("Student ID already exists.\n");
        return;
    }

    printf("Enter student name: ");
    fgets(s.name, MAX_NAME, stdin);
    s.name[strcspn(s.name, "\n")] = '\0';

    printf("Enter course name: ");
    fgets(s.course, MAX_COURSE, stdin);
    s.course[strcspn(s.course, "\n")] = '\0';

    printf("Enter age: ");
    scanf("%d", &s.age);

    printf("Enter %d subject grades:\n", MAX_SUBJECTS);
    for (int i = 0; i < MAX_SUBJECTS; i++) {
        printf("Grade %d: ", i + 1);
        scanf("%f", &s.grades[i]);

        if (s.grades[i] < 0 || s.grades[i] > 100) {
            printf("Invalid grade. Must be between 0 and 100.\n");
            return;
        }
    }

    s.gpa = calculateGPA(s.grades, MAX_SUBJECTS);

    Student *temp = realloc(students, (count + 1) * sizeof(Student));
    if (temp == NULL) {
        printf("Memory allocation failed.\n");
        return;
    }

    students = temp;
    students[count] = s;
    count++;

    printf("Student added successfully.\n");
}

void displayStudents() {
    if (count == 0) {
        printf("No records found.\n");
        return;
    }

    for (int i = 0; i < count; i++) {
        printf("\nStudent %d\n", i + 1);
        printf("ID: %d\n", students[i].id);
        printf("Name: %s\n", students[i].name);
        printf("Course: %s\n", students[i].course);
        printf("Age: %d\n", students[i].age);
        printf("Grades: ");
        for (int j = 0; j < MAX_SUBJECTS; j++) {
            printf("%.2f ", students[i].grades[j]);
        }
        printf("\nGPA: %.2f\n", students[i].gpa);
    }
}

void updateStudent() {
    int id;
    printf("Enter student ID to update: ");
    scanf("%d", &id);
    getchar();

    int index = findStudentById(id);
    if (index == -1) {
        printf("Student not found.\n");
        return;
    }

    printf("Enter new name: ");
    fgets(students[index].name, MAX_NAME, stdin);
    students[index].name[strcspn(students[index].name, "\n")] = '\0';

    printf("Enter new course: ");
    fgets(students[index].course, MAX_COURSE, stdin);
    students[index].course[strcspn(students[index].course, "\n")] = '\0';

    printf("Enter new age: ");
    scanf("%d", &students[index].age);

    printf("Enter %d new grades:\n", MAX_SUBJECTS);
    for (int i = 0; i < MAX_SUBJECTS; i++) {
        printf("Grade %d: ", i + 1);
        scanf("%f", &students[index].grades[i]);

        if (students[index].grades[i] < 0 || students[index].grades[i] > 100) {
            printf("Invalid grade.\n");
            return;
        }
    }

    students[index].gpa = calculateGPA(students[index].grades, MAX_SUBJECTS);
    printf("Student updated successfully.\n");
}

void deleteStudent() {
    int id;
    printf("Enter student ID to delete: ");
    scanf("%d", &id);

    int index = findStudentById(id);
    if (index == -1) {
        printf("Student not found.\n");
        return;
    }

    for (int i = index; i < count - 1; i++) {
        students[i] = students[i + 1];
    }

    count--;
    Student *temp = realloc(students, count * sizeof(Student));
    if (temp != NULL || count == 0) {
        students = temp;
    }

    printf("Student deleted successfully.\n");
}

void searchStudent() {
    int choice;
    printf("Search by:\n");
    printf("1. ID\n");
    printf("2. Name\n");
    printf("Choose option: ");
    scanf("%d", &choice);
    getchar();

    if (choice == 1) {
        int id;
        printf("Enter ID: ");
        scanf("%d", &id);

        int index = findStudentById(id);
        if (index == -1) {
            printf("Student not found.\n");
            return;
        }

        printf("ID: %d\n", students[index].id);
        printf("Name: %s\n", students[index].name);
        printf("Course: %s\n", students[index].course);
        printf("Age: %d\n", students[index].age);
        printf("GPA: %.2f\n", students[index].gpa);
    } else if (choice == 2) {
        char name[MAX_NAME];
        printf("Enter name: ");
        fgets(name, MAX_NAME, stdin);
        name[strcspn(name, "\n")] = '\0';

        int found = 0;
        for (int i = 0; i < count; i++) {
            if (strcmp(students[i].name, name) == 0) {
                printf("ID: %d | Name: %s | GPA: %.2f\n", students[i].id, students[i].name, students[i].gpa);
                found = 1;
            }
        }

        if (!found) {
            printf("Student not found.\n");
        }
    } else {
        printf("Invalid option.\n");
    }
}

void sortById() {
    for (int i = 0; i < count - 1; i++) {
        for (int j = 0; j < count - i - 1; j++) {
            if (students[j].id > students[j + 1].id) {
                Student temp = students[j];
                students[j] = students[j + 1];
                students[j + 1] = temp;
            }
        }
    }
    printf("Sorted by ID.\n");
}

void sortByName() {
    for (int i = 0; i < count - 1; i++) {
        for (int j = 0; j < count - i - 1; j++) {
            if (strcmp(students[j].name, students[j + 1].name) > 0) {
                Student temp = students[j];
                students[j] = students[j + 1];
                students[j + 1] = temp;
            }
        }
    }
    printf("Sorted by name.\n");
}

void sortByGPA() {
    for (int i = 0; i < count - 1; i++) {
        for (int j = 0; j < count - i - 1; j++) {
            if (students[j].gpa < students[j + 1].gpa) {
                Student temp = students[j];
                students[j] = students[j + 1];
                students[j + 1] = temp;
            }
        }
    }
    printf("Sorted by GPA.\n");
}

void showReport() {
    if (count == 0) {
        printf("No records available.\n");
        return;
    }

    float total = 0;
    float highest = students[0].gpa;
    float lowest = students[0].gpa;

    for (int i = 0; i < count; i++) {
        total += students[i].gpa;
        if (students[i].gpa > highest) highest = students[i].gpa;
        if (students[i].gpa < lowest) lowest = students[i].gpa;
    }

    printf("Class Average GPA: %.2f\n", total / count);
    printf("Highest GPA: %.2f\n", highest);
    printf("Lowest GPA: %.2f\n", lowest);
}

void saveToFile() {
    FILE *file = fopen("records.txt", "w");
    if (file == NULL) {
        printf("Error opening file.\n");
        return;
    }

    for (int i = 0; i < count; i++) {
        fprintf(file, "%d,%s,%s,%d", students[i].id, students[i].name, students[i].course, students[i].age);
        for (int j = 0; j < MAX_SUBJECTS; j++) {
            fprintf(file, ",%.2f", students[i].grades[j]);
        }
        fprintf(file, ",%.2f\n", students[i].gpa);
    }

    fclose(file);
    printf("Records saved successfully.\n");
}

void loadFromFile() {
    FILE *file = fopen("records.txt", "r");
    if (file == NULL) {
        printf("No file found.\n");
        return;
    }

    free(students);
    students = NULL;
    count = 0;

    Student s;
    while (fscanf(file, "%d,%99[^,],%99[^,],%d,%f,%f,%f,%f,%f,%f",
                  &s.id, s.name, s.course, &s.age,
                  &s.grades[0], &s.grades[1], &s.grades[2],
                  &s.grades[3], &s.grades[4], &s.gpa) == 10) {
        Student *temp = realloc(students, (count + 1) * sizeof(Student));
        if (temp == NULL) {
            printf("Memory allocation failed.\n");
            fclose(file);
            return;
        }
        students = temp;
        students[count] = s;
        count++;
    }

    fclose(file);
    printf("Records loaded successfully.\n");
}

void menu() {
    int choice;

    do {
        printf("\n--- Academic Records Analyzer ---\n");
        printf("1. Add student\n");
        printf("2. Display students\n");
        printf("3. Update student\n");
        printf("4. Delete student\n");
        printf("5. Search student\n");
        printf("6. Sort by ID\n");
        printf("7. Sort by Name\n");
        printf("8. Sort by GPA\n");
        printf("9. Show report\n");
        printf("10. Save to file\n");
        printf("11. Load from file\n");
        printf("0. Exit\n");
        printf("Choose option: ");
        scanf("%d", &choice);
        getchar();

        switch (choice) {
            case 1: addStudent(); break;
            case 2: displayStudents(); break;
            case 3: updateStudent(); break;
            case 4: deleteStudent(); break;
            case 5: searchStudent(); break;
            case 6: sortById(); break;
            case 7: sortByName(); break;
            case 8: sortByGPA(); break;
            case 9: showReport(); break;
            case 10: saveToFile(); break;
            case 11: loadFromFile(); break;
            case 0: printf("Exiting...\n"); break;
            default: printf("Invalid choice.\n");
        }
    } while (choice != 0);
}

int main() {
    menu();
    free(students);
    return 0;
}