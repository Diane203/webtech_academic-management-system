package com.example.universityacademicsystem;

import com.example.universityacademicsystem.repository.*;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.orm.jpa.DataJpaTest;
import org.springframework.test.context.ActiveProfiles;

import static org.assertj.core.api.Assertions.assertThat;

@DataJpaTest
@ActiveProfiles("test")
class UniversityAcademicSystemApplicationTests {

    @Autowired
    private DepartmentRepository departmentRepository;

    @Autowired
    private StudentRepository studentRepository;

    @Autowired
    private StudentProfileRepository studentProfileRepository;

    @Autowired
    private LecturerRepository lecturerRepository;

    @Autowired
    private CourseRepository courseRepository;

    @Autowired
    private RegistrationRepository registrationRepository;

    @Test
    void contextLoads() {
        assertThat(departmentRepository).isNotNull();
        assertThat(studentRepository).isNotNull();
        assertThat(studentProfileRepository).isNotNull();
        assertThat(lecturerRepository).isNotNull();
        assertThat(courseRepository).isNotNull();
        assertThat(registrationRepository).isNotNull();
    }
}
