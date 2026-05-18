package models;
public class Student {
    private int id;
    private String name, studentNumber, email, program, password;
    private int warningCount;
    private String accountStatus = "ACTIVE";
    public Student() {}
    public Student(String name, String studentNumber, String email, String program, String password) {
        this.name = name; this.studentNumber = studentNumber; this.email = email;
        this.program = program; this.password = password; this.warningCount = 0; this.accountStatus = "ACTIVE";
    }
    public boolean isCriticalBlocked() { return warningCount >= 4; }
    public int getId() { return id; } public void setId(int id) { this.id = id; }
    public String getName() { return name; } public void setName(String name) { this.name = name; }
    public String getStudentNumber() { return studentNumber; } public void setStudentNumber(String n) { this.studentNumber = n; }
    public String getEmail() { return email; } public void setEmail(String email) { this.email = email; }
    public String getProgram() { return program; } public void setProgram(String program) { this.program = program; }
    public String getPassword() { return password; } public void setPassword(String password) { this.password = password; }
    public int getWarningCount() { return warningCount; } public void setWarningCount(int w) { this.warningCount = w; }
    public String getAccountStatus() { return accountStatus != null ? accountStatus : "ACTIVE"; }
    public void setAccountStatus(String accountStatus) { this.accountStatus = accountStatus; }
    public String getWarningLabel() { switch(warningCount) { case 1: return "1st Warning"; case 2: return "2nd Warning"; case 3: return "3rd Warning"; case 4: return "CRITICAL"; default: return "None"; } }
}