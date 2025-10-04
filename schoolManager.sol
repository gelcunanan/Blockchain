// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SchoolManager {

    // --- STRUCTS ---
    struct Teacher {
        uint id;
        string name;
        string department;
        bool exists;
    }

    struct Student {
        uint id;
        string name;
        uint age;
        bool exists;
        uint sectionId; // link to section
    }

    struct Section {
        uint id;
        string name;
        uint teacherId; // link to teacher
        bool exists;
    }

    // --- MAPPINGS ---
    mapping(uint => Teacher) private teachers;
    mapping(uint => Student) private students;
    mapping(uint => Section) private sections;

    // --- RELATIONSHIP MAPPINGS ---
    mapping(uint => uint[]) private sectionStudents; // sectionId → student IDs
    mapping(uint => uint[]) private teacherSections; // teacherId → section IDs

    // --- EVENTS ---
    event TeacherAdded(uint id, string name, string department);
    event StudentAdded(uint id, string name, uint age);
    event SectionAdded(uint id, string name);
    event TeacherAssignedToSection(uint teacherId, uint sectionId);
    event StudentAssignedToSection(uint studentId, uint sectionId);

    // --- TEACHER FUNCTIONS ---
    function addTeacher(uint _id, string memory _name, string memory _department) public {
        require(!teachers[_id].exists, "Teacher already exists!");
        teachers[_id] = Teacher(_id, _name, _department, true);
        emit TeacherAdded(_id, _name, _department);
    }

    // --- STUDENT FUNCTIONS ---
    function addStudent(uint _id, string memory _name, uint _age) public {
        require(!students[_id].exists, "Student already exists!");
        students[_id] = Student(_id, _name, _age, true, 0);
        emit StudentAdded(_id, _name, _age);
    }

    // --- SECTION FUNCTIONS ---
    function addSection(uint _id, string memory _name) public {
        require(!sections[_id].exists, "Section already exists!");
        sections[_id] = Section(_id, _name, 0, true);
        emit SectionAdded(_id, _name);
    }

    // --- ASSIGNMENT FUNCTIONS ---
    function assignTeacherToSection(uint _teacherId, uint _sectionId) public {
        require(teachers[_teacherId].exists, "Teacher not found!");
        require(sections[_sectionId].exists, "Section not found!");
        sections[_sectionId].teacherId = _teacherId;
        teacherSections[_teacherId].push(_sectionId);
        emit TeacherAssignedToSection(_teacherId, _sectionId);
    }

    function assignStudentToSection(uint _studentId, uint _sectionId) public {
        require(students[_studentId].exists, "Student not found!");
        require(sections[_sectionId].exists, "Section not found!");
        students[_studentId].sectionId = _sectionId;
        sectionStudents[_sectionId].push(_studentId);
        emit StudentAssignedToSection(_studentId, _sectionId);
    }

    // --- SEARCH / VIEW FUNCTIONS ---
    function getTeacher(uint _teacherId) public view returns (uint id, string memory name, string memory department) {
        require(teachers[_teacherId].exists, "Teacher not found!");
        Teacher memory t = teachers[_teacherId];
        return (t.id, t.name, t.department);
    }

    function getStudent(uint _studentId) public view returns (uint id, string memory name, uint age, uint sectionId) {
        require(students[_studentId].exists, "Student not found!");
        Student memory s = students[_studentId];
        return (s.id, s.name, s.age, s.sectionId);
    }

    function getSection(uint _sectionId) public view returns (uint id, string memory name, uint teacherId) {
        require(sections[_sectionId].exists, "Section not found!");
        Section memory sec = sections[_sectionId];
        return (sec.id, sec.name, sec.teacherId);
    }

    function getStudentsInSection(uint _sectionId) public view returns (uint[] memory) {
        return sectionStudents[_sectionId];
    }

    function getSectionsOfTeacher(uint _teacherId) public view returns (uint[] memory) {
        return teacherSections[_teacherId];
    }
}
