<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.Statement" %>
<%@ page import="java.sql.SQLException" %>

<%
    /*
     * Database connection information for the CSD430 database.
     */
    String url = "jdbc:mysql://localhost:3306/CSD430";
    String username = "student1";
    String password = "pass";

    Connection connection = null;
    PreparedStatement insertStatement = null;
    Statement selectStatement = null;
    ResultSet resultSet = null;

    String successMessage = "";
    String errorMessage = "";

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        connection = DriverManager.getConnection(url, username, password);

        /*
         * When the form is submitted, collect the entered values and
         * insert a new record. The state_id key is generated automatically.
         */
        if ("POST".equalsIgnoreCase(request.getMethod())) {
            String stateName = request.getParameter("stateName");
            String abbreviation = request.getParameter("abbreviation");
            String capital = request.getParameter("capital");
            String populationValue = request.getParameter("population");
            String region = request.getParameter("region");

            if (stateName != null && !stateName.trim().isEmpty()
                    && abbreviation != null && !abbreviation.trim().isEmpty()
                    && capital != null && !capital.trim().isEmpty()
                    && populationValue != null && !populationValue.trim().isEmpty()
                    && region != null && !region.trim().isEmpty()) {

                int population = Integer.parseInt(populationValue);

                String insertSql =
                    "INSERT INTO rashaistatesdata " +
                    "(state_name, abbreviation, capital, population, region) " +
                    "VALUES (?, ?, ?, ?, ?)";

                insertStatement = connection.prepareStatement(insertSql);
                insertStatement.setString(1, stateName.trim());
                insertStatement.setString(2, abbreviation.trim().toUpperCase());
                insertStatement.setString(3, capital.trim());
                insertStatement.setInt(4, population);
                insertStatement.setString(5, region.trim());

                int rowsAdded = insertStatement.executeUpdate();

                if (rowsAdded > 0) {
                    successMessage = "The new state record was added successfully.";
                }
            } else {
                errorMessage = "Please complete every form field.";
            }
        }

        /*
         * Retrieve every record so the complete database table is displayed.
         */
        String selectSql =
            "SELECT state_id, state_name, abbreviation, capital, population, region " +
            "FROM rashaistatesdata ORDER BY state_id";

        selectStatement = connection.createStatement();
        resultSet = selectStatement.executeQuery(selectSql);

    } catch (NumberFormatException e) {
        errorMessage = "Population must be entered as a valid whole number.";
    } catch (ClassNotFoundException e) {
        errorMessage = "The MySQL JDBC driver could not be found.";
    } catch (SQLException e) {
        errorMessage = "Database error: " + e.getMessage();
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Rashai States Data</title>
</head>
<body>

<h1>Rashai States Database</h1>

<p>
    This page allows a new state record to be added to the MySQL database
    named CSD430. After submission, all records are displayed in the table below.
</p>

<h2>Add a New State Record</h2>

<form method="post" action="states.jsp">
    <p>
        <label for="stateName">State Name:</label><br>
        <input type="text" id="stateName" name="stateName" required>
    </p>

    <p>
        <label for="abbreviation">Abbreviation:</label><br>
        <input type="text" id="abbreviation" name="abbreviation" maxlength="2" required>
    </p>

    <p>
        <label for="capital">Capital:</label><br>
        <input type="text" id="capital" name="capital" required>
    </p>

    <p>
        <label for="population">Population:</label><br>
        <input type="number" id="population" name="population" min="0" required>
    </p>

    <p>
        <label for="region">Region:</label><br>
        <select id="region" name="region" required>
            <option value="">Select a region</option>
            <option value="Northeast">Northeast</option>
            <option value="Midwest">Midwest</option>
            <option value="South">South</option>
            <option value="West">West</option>
        </select>
    </p>

    <p>
        <input type="submit" value="Add State">
    </p>
</form>

<% if (!successMessage.isEmpty()) { %>
<p><strong><%= successMessage %></strong></p>
<% } %>

<% if (!errorMessage.isEmpty()) { %>
<p><strong><%= errorMessage %></strong></p>
<% } %>

<h2>All State Records</h2>

<p>
    Each row below represents one record stored in the rashaistatesdata table.
</p>

<table border="1">
    <thead>
        <tr>
            <th>State ID</th>
            <th>State Name</th>
            <th>Abbreviation</th>
            <th>Capital</th>
            <th>Population</th>
            <th>Region</th>
        </tr>
    </thead>
    <tbody>

    <%
        boolean recordFound = false;

        if (resultSet != null) {
            while (resultSet.next()) {
                recordFound = true;
    %>

        <tr>
            <td><%= resultSet.getInt("state_id") %></td>
            <td><%= resultSet.getString("state_name") %></td>
            <td><%= resultSet.getString("abbreviation") %></td>
            <td><%= resultSet.getString("capital") %></td>
            <td><%= resultSet.getInt("population") %></td>
            <td><%= resultSet.getString("region") %></td>
        </tr>

    <%
            }
        }

        if (!recordFound) {
    %>

        <tr>
            <td colspan="6">No state records are currently available.</td>
        </tr>

    <%
        }
    %>

    </tbody>
</table>

<p>
    <a href="index.jsp">Return to Project Index</a>
</p>

</body>
</html>

<%
    /* Close all database resources after the page has been generated. */
    try {
        if (resultSet != null) {
            resultSet.close();
        }
        if (selectStatement != null) {
            selectStatement.close();
        }
        if (insertStatement != null) {
            insertStatement.close();
        }
        if (connection != null) {
            connection.close();
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }
%>
