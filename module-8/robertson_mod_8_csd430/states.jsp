<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.Statement" %>
<%@ page import="java.sql.SQLException" %>

<%
    /*
     * Project Part 3 - Add and Update State Records
     *
     * The updates to my JSP allow users to add new records,
     * select an existing record by its primary key, edit the non-key fields,
     * update the database, and view the updated record in table format.
     * I also updated the style.
     */

    String url = "jdbc:mysql://localhost:3306/CSD430";
    String username = "student1";
    String password = "pass";

    Connection connection = null;
    PreparedStatement insertStatement = null;
    PreparedStatement updateStatement = null;
    PreparedStatement selectedRecordStatement = null;
    PreparedStatement updatedRecordStatement = null;
    Statement dropdownStatement = null;
    Statement allRecordsStatement = null;
    ResultSet selectedRecordResult = null;
    ResultSet updatedRecordResult = null;
    ResultSet dropdownResult = null;
    ResultSet allRecordsResult = null;

    String successMessage = "";
    String errorMessage = "";
    String action = request.getParameter("action");

    int selectedStateId = 0;
    String selectedStateName = "";
    String selectedAbbreviation = "";
    String selectedCapital = "";
    int selectedPopulation = 0;
    String selectedRegion = "";
    boolean selectedRecordFound = false;

    int updatedStateId = 0;
    String updatedStateName = "";
    String updatedAbbreviation = "";
    String updatedCapital = "";
    int updatedPopulation = 0;
    String updatedRegion = "";
    boolean showUpdatedRecord = false;

    try {
        request.setCharacterEncoding("UTF-8");

        Class.forName("com.mysql.cj.jdbc.Driver");
        connection = DriverManager.getConnection(url, username, password);

        /*
         * Insert a new record when the Add State form is submitted.
         */
        if ("insert".equals(action)) {
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
                errorMessage = "Please complete every field in the add form.";
            }
        }

        /*
         * Update an existing record when the Update Record form is submitted.
         * The state_id key is used in the WHERE clause and is not editable.
         */
        if ("update".equals(action)) {
            String stateIdValue = request.getParameter("stateId");
            String stateName = request.getParameter("updateStateName");
            String abbreviation = request.getParameter("updateAbbreviation");
            String capital = request.getParameter("updateCapital");
            String populationValue = request.getParameter("updatePopulation");
            String region = request.getParameter("updateRegion");

            if (stateIdValue != null && !stateIdValue.trim().isEmpty()
                    && stateName != null && !stateName.trim().isEmpty()
                    && abbreviation != null && !abbreviation.trim().isEmpty()
                    && capital != null && !capital.trim().isEmpty()
                    && populationValue != null && !populationValue.trim().isEmpty()
                    && region != null && !region.trim().isEmpty()) {

                int stateId = Integer.parseInt(stateIdValue);
                int population = Integer.parseInt(populationValue);

                String updateSql =
                    "UPDATE rashaistatesdata SET state_name = ?, abbreviation = ?, " +
                    "capital = ?, population = ?, region = ? WHERE state_id = ?";

                updateStatement = connection.prepareStatement(updateSql);
                updateStatement.setString(1, stateName.trim());
                updateStatement.setString(2, abbreviation.trim().toUpperCase());
                updateStatement.setString(3, capital.trim());
                updateStatement.setInt(4, population);
                updateStatement.setString(5, region.trim());
                updateStatement.setInt(6, stateId);

                int rowsUpdated = updateStatement.executeUpdate();

                if (rowsUpdated > 0) {
                    successMessage = "The selected state record was updated successfully.";

                    /* Retrieve the updated record for the required results table. */
                    String updatedRecordSql =
                        "SELECT state_id, state_name, abbreviation, capital, population, region " +
                        "FROM rashaistatesdata WHERE state_id = ?";

                    updatedRecordStatement = connection.prepareStatement(updatedRecordSql);
                    updatedRecordStatement.setInt(1, stateId);
                    updatedRecordResult = updatedRecordStatement.executeQuery();

                    if (updatedRecordResult.next()) {
                        updatedStateId = updatedRecordResult.getInt("state_id");
                        updatedStateName = updatedRecordResult.getString("state_name");
                        updatedAbbreviation = updatedRecordResult.getString("abbreviation");
                        updatedCapital = updatedRecordResult.getString("capital");
                        updatedPopulation = updatedRecordResult.getInt("population");
                        updatedRegion = updatedRecordResult.getString("region");
                        showUpdatedRecord = true;
                    }
                } else {
                    errorMessage = "The selected state record could not be found.";
                }
            } else {
                errorMessage = "Please complete every field in the update form.";
            }
        }

        /*
         * Load the record selected from the key-value dropdown.
         */
        String selectedIdValue = request.getParameter("selectedId");

        if ("load".equals(action) && selectedIdValue != null
                && !selectedIdValue.trim().isEmpty()) {

            selectedStateId = Integer.parseInt(selectedIdValue);

            String selectedRecordSql =
                "SELECT state_id, state_name, abbreviation, capital, population, region " +
                "FROM rashaistatesdata WHERE state_id = ?";

            selectedRecordStatement = connection.prepareStatement(selectedRecordSql);
            selectedRecordStatement.setInt(1, selectedStateId);
            selectedRecordResult = selectedRecordStatement.executeQuery();

            if (selectedRecordResult.next()) {
                selectedStateName = selectedRecordResult.getString("state_name");
                selectedAbbreviation = selectedRecordResult.getString("abbreviation");
                selectedCapital = selectedRecordResult.getString("capital");
                selectedPopulation = selectedRecordResult.getInt("population");
                selectedRegion = selectedRecordResult.getString("region");
                selectedRecordFound = true;
            } else {
                errorMessage = "The selected state record could not be found.";
            }
        }

        /* Retrieve all key values for the update dropdown. */
        dropdownStatement = connection.createStatement();
        dropdownResult = dropdownStatement.executeQuery(
            "SELECT state_id, state_name FROM rashaistatesdata ORDER BY state_id"
        );

        /* Retrieve all records for the complete database table. */
        allRecordsStatement = connection.createStatement();
        allRecordsResult = allRecordsStatement.executeQuery(
            "SELECT state_id, state_name, abbreviation, capital, population, region " +
            "FROM rashaistatesdata ORDER BY state_id"
        );

    } catch (NumberFormatException e) {
        errorMessage = "State ID and population must be valid whole numbers.";
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
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Rashai States Data</title>

    <style>
        * {
            box-sizing: border-box;
        }

        body {
            margin: 0;
            padding: 30px 18px;
            font-family: Arial, Helvetica, sans-serif;
            color: #243447;
            background: #eef2f6;
        }

        .page-container {
            width: 100%;
            max-width: 1050px;
            margin: 0 auto;
        }

        .page-header,
        .card {
            background: #ffffff;
            border-radius: 12px;
            box-shadow: 0 5px 18px rgba(0, 0, 0, 0.10);
        }

        .page-header {
            padding: 28px;
            margin-bottom: 24px;
            text-align: center;
        }

        .page-header h1 {
            margin: 0 0 10px;
            color: #1f4f7a;
        }

        .page-header p {
            margin: 0;
            line-height: 1.6;
        }

        .card {
            padding: 26px;
            margin-bottom: 24px;
        }

        h2 {
            margin-top: 0;
            color: #1f4f7a;
            border-bottom: 2px solid #d8e4ee;
            padding-bottom: 10px;
        }

        .form-grid {
            display: grid;
            grid-template-columns: repeat(2, minmax(0, 1fr));
            gap: 18px;
        }

        .form-group {
            display: flex;
            flex-direction: column;
        }

        .form-group.full-width {
            grid-column: 1 / -1;
        }

        label {
            margin-bottom: 7px;
            font-weight: bold;
        }

        input,
        select {
            width: 100%;
            padding: 11px 12px;
            border: 1px solid #aebdcc;
            border-radius: 6px;
            font-size: 15px;
            background: #ffffff;
        }

        input:focus,
        select:focus {
            outline: none;
            border-color: #2b6ca3;
            box-shadow: 0 0 0 3px rgba(43, 108, 163, 0.15);
        }

        .key-display {
            padding: 11px 12px;
            border: 1px solid #b7c2cc;
            border-radius: 6px;
            background: #e9eef3;
            font-weight: bold;
        }

        .button-row {
            margin-top: 20px;
        }

        .button {
            display: inline-block;
            width: auto;
            padding: 11px 20px;
            border: none;
            border-radius: 6px;
            color: white;
            background: #28679a;
            font-size: 15px;
            font-weight: bold;
            cursor: pointer;
        }

        .button:hover {
            background: #1d5078;
        }

        .message {
            padding: 14px 16px;
            margin-bottom: 22px;
            border-radius: 7px;
            font-weight: bold;
        }

        .success {
            color: #195c2c;
            background: #dcf3e3;
            border: 1px solid #8bc99b;
        }

        .error {
            color: #842029;
            background: #f8d7da;
            border: 1px solid #d99aa0;
        }

        .table-wrapper {
            overflow-x: auto;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 14px;
        }

        th,
        td {
            padding: 12px;
            border: 1px solid #c8d2dc;
            text-align: left;
        }

        th {
            color: #ffffff;
            background: #285f8f;
        }

        tbody tr:nth-child(even) {
            background: #f5f8fa;
        }

        .field-type {
            display: block;
            margin-top: 3px;
            font-size: 12px;
            font-weight: normal;
            color: #dceaf5;
        }

        .navigation {
            text-align: center;
            padding: 8px 0 25px;
        }

        .navigation a {
            color: #1f5f91;
            font-weight: bold;
            text-decoration: none;
        }

        .navigation a:hover {
            text-decoration: underline;
        }

        @media (max-width: 700px) {
            .form-grid {
                grid-template-columns: 1fr;
            }

            .form-group.full-width {
                grid-column: auto;
            }

            .card,
            .page-header {
                padding: 20px;
            }
        }
    </style>
</head>
<body>

<div class="page-container">

    <header class="page-header">
        <h1>Rashai States Database</h1>
        <p>
            Add a new state record or select an existing record to update.
        </p>
    </header>

    <% if (!successMessage.isEmpty()) { %>
        <div class="message success"><%= successMessage %></div>
    <% } %>

    <% if (!errorMessage.isEmpty()) { %>
        <div class="message error"><%= errorMessage %></div>
    <% } %>

    <section class="card">
        <h2>Add a New State Record</h2>

        <form method="post" action="states.jsp">
            <input type="hidden" name="action" value="insert">

            <div class="form-grid">
                <div class="form-group">
                    <label for="stateName">State Name:</label>
                    <input type="text" id="stateName" name="stateName" required>
                </div>

                <div class="form-group">
                    <label for="abbreviation">Abbreviation:</label>
                    <input type="text" id="abbreviation" name="abbreviation" maxlength="2" required>
                </div>

                <div class="form-group">
                    <label for="capital">Capital:</label>
                    <input type="text" id="capital" name="capital" required>
                </div>

                <div class="form-group">
                    <label for="population">Population:</label>
                    <input type="number" id="population" name="population" min="0" required>
                </div>

                <div class="form-group full-width">
                    <label for="region">Region:</label>
                    <select id="region" name="region" required>
                        <option value="">Select a region</option>
                        <option value="Northeast">Northeast</option>
                        <option value="Midwest">Midwest</option>
                        <option value="South">South</option>
                        <option value="West">West</option>
                    </select>
                </div>
            </div>

            <div class="button-row">
                <input class="button" type="submit" value="Add State">
            </div>
        </form>
    </section>

    <section class="card">
        <h2>Select a State Record to Update</h2>

        <form method="get" action="states.jsp">
            <input type="hidden" name="action" value="load">

            <div class="form-group">
                <label for="selectedId">State Record Key:</label>
                <select id="selectedId" name="selectedId" required>
                    <option value="">Select a state record</option>

                    <% if (dropdownResult != null) {
                        while (dropdownResult.next()) { %>

                        <option value="<%= dropdownResult.getInt("state_id") %>"
                            <%= selectedStateId == dropdownResult.getInt("state_id") ? "selected" : "" %>>
                            <%= dropdownResult.getInt("state_id") %> -
                            <%= dropdownResult.getString("state_name") %>
                        </option>

                    <%  }
                    } %>
                </select>
            </div>

            <div class="button-row">
                <input class="button" type="submit" value="Load Record">
            </div>
        </form>
    </section>

    <% if (selectedRecordFound) { %>
        <section class="card">
            <h2>Update Selected State Record</h2>

            <form method="post" action="states.jsp">
                <input type="hidden" name="action" value="update">
                <input type="hidden" name="stateId" value="<%= selectedStateId %>">

                <div class="form-grid">
                    <div class="form-group">
                        <label>State ID (Primary Key):</label>
                        <div class="key-display"><%= selectedStateId %></div>
                    </div>

                    <div class="form-group">
                        <label for="updateStateName">State Name:</label>
                        <input type="text" id="updateStateName" name="updateStateName"
                               value="<%= selectedStateName %>" required>
                    </div>

                    <div class="form-group">
                        <label for="updateAbbreviation">Abbreviation:</label>
                        <input type="text" id="updateAbbreviation" name="updateAbbreviation"
                               value="<%= selectedAbbreviation %>" maxlength="2" required>
                    </div>

                    <div class="form-group">
                        <label for="updateCapital">Capital:</label>
                        <input type="text" id="updateCapital" name="updateCapital"
                               value="<%= selectedCapital %>" required>
                    </div>

                    <div class="form-group">
                        <label for="updatePopulation">Population:</label>
                        <input type="number" id="updatePopulation" name="updatePopulation"
                               value="<%= selectedPopulation %>" min="0" required>
                    </div>

                    <div class="form-group">
                        <label for="updateRegion">Region:</label>
                        <select id="updateRegion" name="updateRegion" required>
                            <option value="Northeast" <%= "Northeast".equals(selectedRegion) ? "selected" : "" %>>Northeast</option>
                            <option value="Midwest" <%= "Midwest".equals(selectedRegion) ? "selected" : "" %>>Midwest</option>
                            <option value="South" <%= "South".equals(selectedRegion) ? "selected" : "" %>>South</option>
                            <option value="West" <%= "West".equals(selectedRegion) ? "selected" : "" %>>West</option>
                        </select>
                    </div>
                </div>

                <div class="button-row">
                    <input class="button" type="submit" value="Update Record">
                </div>
            </form>
        </section>
    <% } %>

    <% if (showUpdatedRecord) { %>
        <section class="card">
            <h2>Updated Record</h2>
            <p>The table below displays the updated record and each field type.</p>

            <div class="table-wrapper">
                <table>
                    <thead>
                        <tr>
                            <th>State ID<span class="field-type">INT - Primary Key</span></th>
                            <th>State Name<span class="field-type">VARCHAR</span></th>
                            <th>Abbreviation<span class="field-type">VARCHAR</span></th>
                            <th>Capital<span class="field-type">VARCHAR</span></th>
                            <th>Population<span class="field-type">INT</span></th>
                            <th>Region<span class="field-type">VARCHAR</span></th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td><%= updatedStateId %></td>
                            <td><%= updatedStateName %></td>
                            <td><%= updatedAbbreviation %></td>
                            <td><%= updatedCapital %></td>
                            <td><%= updatedPopulation %></td>
                            <td><%= updatedRegion %></td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </section>
    <% } %>

    <section class="card">
        <h2>All State Records</h2>
        <p>Each row represents one record stored in the rashaistatesdata table.</p>

        <div class="table-wrapper">
            <table>
                <thead>
                    <tr>
                        <th>State ID<span class="field-type">INT</span></th>
                        <th>State Name<span class="field-type">VARCHAR</span></th>
                        <th>Abbreviation<span class="field-type">VARCHAR</span></th>
                        <th>Capital<span class="field-type">VARCHAR</span></th>
                        <th>Population<span class="field-type">INT</span></th>
                        <th>Region<span class="field-type">VARCHAR</span></th>
                    </tr>
                </thead>
                <tbody>

                <%
                    boolean recordFound = false;

                    if (allRecordsResult != null) {
                        while (allRecordsResult.next()) {
                            recordFound = true;
                %>

                    <tr>
                        <td><%= allRecordsResult.getInt("state_id") %></td>
                        <td><%= allRecordsResult.getString("state_name") %></td>
                        <td><%= allRecordsResult.getString("abbreviation") %></td>
                        <td><%= allRecordsResult.getString("capital") %></td>
                        <td><%= allRecordsResult.getInt("population") %></td>
                        <td><%= allRecordsResult.getString("region") %></td>
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
        </div>
    </section>

    <div class="navigation">
        <a href="index.jsp">Return to Project Index</a>
    </div>

</div>

</body>
</html>

<%
    /* Close all database resources after the page has been generated. */
    try {
        if (selectedRecordResult != null) selectedRecordResult.close();
        if (updatedRecordResult != null) updatedRecordResult.close();
        if (dropdownResult != null) dropdownResult.close();
        if (allRecordsResult != null) allRecordsResult.close();
        if (insertStatement != null) insertStatement.close();
        if (updateStatement != null) updateStatement.close();
        if (selectedRecordStatement != null) selectedRecordStatement.close();
        if (updatedRecordStatement != null) updatedRecordStatement.close();
        if (dropdownStatement != null) dropdownStatement.close();
        if (allRecordsStatement != null) allRecordsStatement.close();
        if (connection != null) connection.close();
    } catch (SQLException e) {
        e.printStackTrace();
    }
%>
