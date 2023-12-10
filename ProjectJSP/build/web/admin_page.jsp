<%@ page import="java.sql.*" %>
<%@ page import="java.io.*" %>
<%@ page import="javax.servlet.*" %>
<%@ page import="javax.servlet.http.*" %>
<%@ page import="java.sql.*" %>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard</title>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.16.0/umd/popper.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</head>
<style>
    body {
        background-image: url('blue-color-background.jpg');
    }
    
    .table {
        background-image: none;
    }
</style>
<script>
    function enableEdit(inputId) {
        var input = document.getElementById(inputId);
        input.disabled = false;
        input.value = "";
    }
</script>

<%
    String userid = "";
    String email = "";
    String role = "";
    String registerDate = "";
    String username = request.getParameter("username");
    String errorMessage = "";

    // Establish database connection
    String jdbcURL = "jdbc:mysql://localhost:3306/user";
    String dbUsername = "user1";
    String dbPassword = "12345678";

    try {
        Class.forName("com.mysql.jdbc.Driver");
        Connection conn = DriverManager.getConnection(jdbcURL, dbUsername, dbPassword);

        // Retrieve all rows from the login table
        String loginQuery = "SELECT * FROM login";
        PreparedStatement loginStmt = conn.prepareStatement(loginQuery);
        ResultSet loginResult = loginStmt.executeQuery();

        while (loginResult.next()) {
            // Retrieve the register date from the login table
            registerDate = loginResult.getString("register_date");
            userid = loginResult.getString("username");

            // Retrieve personal information using a join operation
            String personalQuery = "SELECT * FROM personal WHERE username = ?";
            PreparedStatement personalStmt = conn.prepareStatement(personalQuery);
            personalStmt.setString(1, userid);
            ResultSet personalResult = personalStmt.executeQuery();

            if (personalResult.next()) {
                // Retrieve the personal information from the result set
                String fullname = personalResult.getString("fullname");
                email = personalResult.getString("email");
                role = personalResult.getString("subject");

                // Display the retrieved values
%> 
<body>
    <div class="container">
        <h1 class="mt-5">Welcome to Administration Page</h1><br>

        <div class="row">
            <div class="col-md-6">
                <h3>User Information</h3>
              
                <form method="post" action="update_admin.jsp?username=<%= userid %>">

                    <table class="table">
                        <thead>
                            <tr>
                                <th>UserID</th>
                                <th>Full Name</th>
                                <th>Email</th>
                                <th>Role</th>
                                <th>Register Date</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% String message = (String) request.getAttribute("message"); %>
                            <% if (message != null && !message.isEmpty()) { %>
                            <p><%= message %></p>
                            <% } else if (errorMessage != null && !errorMessage.isEmpty()) { %>
                            <p><%= errorMessage %></p>
                            <% } %>
                            <tr>
                                <td><input type="text" name="userid" id="userid" value="<%= userid %>" disabled></td>
                                <td><input type="button" value="Modify" onclick="enableEdit('userid')"></td>
                                <td><input type="text" name="fullname" id="fullname" value="<%= fullname %>" disabled></td>
                                <td><input type="button" value="Modify" onclick="enableEdit('fullname')"></td>
                                <td><input type="email" name="email" id="email" value="<%= email %>" disabled></td>
                                <td><input type="button" value="Modify" onclick="enableEdit('email')"></td>
                                <td><input type="text" name="role" id="role" value="<%= role %>" disabled></td>
                                <td><input type="button" value="Modify" onclick="enableEdit('role')"></td>
                                <td><input type="text" name="registerDate" id="registerDate" value="<%= registerDate %>" disabled></td>
                                <td><input type="button" value="Modify" onclick="enableEdit('registerDate')"></td>
                            </tr>
                        </tbody>
                    </table>
                    <input type="submit" value="Update">
                </form>
            </div>
        </div>
    </div>
</body>

</html>
<%
            } else {
                errorMessage = "No personal record found for the username: " + userid;
            }

            personalResult.close();
            personalStmt.close();
        }

        loginResult.close();
        loginStmt.close();
        conn.close();
    } catch (ClassNotFoundException | SQLException e) {
        e.printStackTrace();
    }
%>