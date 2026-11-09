CREATE TABLE 
    activity 
    ( 
        id_activity        INTEGER NOT NULL, 
        title              CHARACTER VARYING(150), 
        description        CHARACTER VARYING(500), 
        due_date           DATE, 
        subject_id_subject INTEGER NOT NULL, 
        CONSTRAINT activity_pk PRIMARY KEY (id_activity, subject_id_subject), 
        CONSTRAINT activity_subject_fk FOREIGN KEY (subject_id_subject) REFERENCES "subject" 
        ("id_subject") 
    );
CREATE TABLE 
    grade 
    ( 
        id_grade INTEGER NOT NULL, 
        "name"   CHARACTER VARYING(50) NOT NULL, 
        PRIMARY KEY (id_grade) 
    );
CREATE TABLE 
    grade_item 
    ( 
        "period"                    INTEGER NOT NULL, 
        "year"                      INTEGER NOT NULL, 
        score                       NUMERIC(3,1), 
        observation                 CHARACTER VARYING(255), 
        activity_id_activity        INTEGER NOT NULL, 
        activity_subject_id_subject INTEGER NOT NULL, 
        student_id_student          INTEGER NOT NULL, 
        teacher_id_teacher          INTEGER NOT NULL, 
        CONSTRAINT grade_item_pk PRIMARY KEY ("period", "year", activity_id_activity, 
        activity_subject_id_subject, student_id_student, teacher_id_teacher), 
        CONSTRAINT grade_item_activity_fk FOREIGN KEY (activity_id_activity, 
        activity_subject_id_subject) REFERENCES "activity" ("id_activity", "subject_id_subject"), 
        CONSTRAINT grade_item_student_fk FOREIGN KEY (student_id_student) REFERENCES "student" 
        ("id_student"), 
        CONSTRAINT grade_item_teacher_fk FOREIGN KEY (teacher_id_teacher) REFERENCES "teacher" 
        ("id_teacher") 
    );
CREATE TABLE 
    grade_item_audit 
    ( 
        id     BIGINT NOT NULL GENERATED ALWAYS AS IDENTITY (SEQUENCE NAME grade_item_audit_id_seq), 
        operation  TEXT NOT NULL, 
        changed_at TIMESTAMP(6) WITH TIME ZONE DEFAULT now() NOT NULL, 
        changed_by TEXT DEFAULT CURRENT_USER NOT NULL, 
        old_data JSONB, 
        new_data JSONB, 
        PRIMARY KEY (id) 
    );
CREATE TABLE 
    school_group 
    ( 
        id_group       INTEGER NOT NULL, 
        "name"         CHARACTER VARYING(50), 
        grade_id_grade INTEGER NOT NULL, 
        CONSTRAINT school_group_pk PRIMARY KEY (id_group, grade_id_grade), 
        CONSTRAINT school_group_grade_fk FOREIGN KEY (grade_id_grade) REFERENCES "grade" 
        ("id_grade") 
    );
CREATE TABLE 
    specialization 
    ( 
        id_specialization INTEGER NOT NULL, 
        specialization    CHARACTER VARYING(20), 
        PRIMARY KEY (id_specialization) 
    );
CREATE TABLE 
    student 
    ( 
        id_student           INTEGER NOT NULL, 
        name_1               CHARACTER VARYING(50), 
        name_2               CHARACTER VARYING(50), 
        last_name_1          CHARACTER VARYING(50), 
        last_name_2          CHARACTER VARYING(50), 
        email                CHARACTER VARYING(100), 
        group_id_group       INTEGER, 
        group_grade_id_grade INTEGER, 
        PRIMARY KEY (id_student), 
        CONSTRAINT student_group_fk FOREIGN KEY (group_id_group, group_grade_id_grade) REFERENCES 
        "school_group" ("id_group", "grade_id_grade") 
    );
CREATE TABLE 
    subject 
    ( 
        id_subject INTEGER NOT NULL, 
        "name"     CHARACTER VARYING(50) NOT NULL, 
        PRIMARY KEY (id_subject) 
    );
CREATE TABLE 
    teacher 
    ( 
        id_teacher                       INTEGER NOT NULL, 
        name_1                           CHARACTER VARYING(50), 
        name_2                           CHARACTER VARYING(50), 
        last_name_1                      CHARACTER VARYING(50), 
        last_name_2                      CHARACTER VARYING(50), 
        email                            CHARACTER VARYING(100), 
        specialization_id_specialization INTEGER, 
        PRIMARY KEY (id_teacher), 
        CONSTRAINT teacher_specialization_fk FOREIGN KEY (specialization_id_specialization) 
        REFERENCES "specialization" ("id_specialization") 
    );
CREATE TABLE 
    teacher_charge 
    ( 
        id_teacher_charge    INTEGER NOT NULL, 
        day_of_week          CHARACTER VARYING(20), 
        hour_start           TIMESTAMP(6) WITH TIME ZONE, 
        hour_end             TIMESTAMP(6) WITH TIME ZONE, 
        group_id_group       INTEGER, 
        group_grade_id_grade INTEGER, 
        subject_id_subject   INTEGER, 
        teacher_id_teacher   INTEGER, 
        PRIMARY KEY (id_teacher_charge), 
        CONSTRAINT teacher_charge_group_fk FOREIGN KEY (group_id_group, group_grade_id_grade) 
        REFERENCES "school_group" ("id_group", "grade_id_grade"), 
        CONSTRAINT teacher_charge_subject_fk FOREIGN KEY (subject_id_subject) REFERENCES "subject" 
        ("id_subject"), 
        CONSTRAINT teacher_charge_teacher_fk FOREIGN KEY (teacher_id_teacher) REFERENCES "teacher" 
        ("id_teacher") 
    );
