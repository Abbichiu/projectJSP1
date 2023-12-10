<%@ page import="java.sql.*" %>
<%@ page import="javax.servlet.*" %>
<%@ page import="javax.servlet.http.*" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.HashMap" %>

<%
    HttpSession sessionObj = request.getSession();
    String username = (String) sessionObj.getAttribute("username");
   
    String cgpa = request.getParameter("cgpa");
    String gpa = request.getParameter("gpa");
    double cgpaValue = Double.parseDouble(cgpa);
    double gpaValue = Double.parseDouble(gpa);
    String studid = request.getParameter("studid");
   
    // Establish database connection
    String jdbcURL = "jdbc:mysql://localhost:3306/user";
    String dbUsername = "user1";
    String dbPassword = "12345678";

    Connection conn = null;
    PreparedStatement updateStudentStmt = null;
    boolean success = false;

    try {
        Class.forName("com.mysql.jdbc.Driver");
        conn = DriverManager.getConnection(jdbcURL, dbUsername, dbPassword);

        // Update the student's CGPA and GPA
        String updateStudentQuery = "UPDATE student SET cgpa = ?, gpa = ? WHERE  studid = ?";
        updateStudentStmt = conn.prepareStatement(updateStudentQuery);
        updateStudentStmt.setDouble(1, cgpaValue);
        updateStudentStmt.setDouble(2, gpaValue);
        updateStudentStmt.setString(3,  studid);
        int studentUpdateCount = updateStudentStmt.executeUpdate();

        if (studentUpdateCount > 0) {
            success = true;
            // Update successful
        }

        if (success) {
            String message = "Successfully updated student's record";
            request.setAttribute("message", message);
            request.getRequestDispatcher("update_record.jsp?username=" + username).forward(request, response);
        } else {
            // Update failed
            String message = "Failed to update student's record";
            request.setAttribute("message", message);
            request.getRequestDispatcher("update_record.jsp?username=" + username).forward(request, response);
        }
    } catch (SQLException e) {
        e.printStackTrace();
        String message = "An error occurred while updating student's record";
        request.setAttribute("message", message);
        request.getRequestDispatcher("update_record.jsp?username=" + username).forward(request, response);
    } catch (ClassNotFoundException e) {
        e.printStackTrace();
        String message = "Database driver not found";
        request.setAttribute("message", message);
        request.getRequestDispatcher("update_record.jsp?username=" + username).forward(request, response);
    } finally {
        // Close the prepared statements and connection
        if (updateStudentStmt != null) {
            try {
                updateStudentStmt.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        if (conn != null) {
            try {
                conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
%>