<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    /*
        This JSP Scriptlet stores movie data for one movie.
        The movie selected is The Dark Knight.
        Each record has three fields:
        category, name, and description.
    */

     String movieTitle = "Forrest Gump";

    String[][] movieRecords = {
        {"Actor", "Tom Hanks", "Played Forrest Gump"},
        {"Actor", "Robin Wright", "Played Jenny Curran"},
        {"Director", "Robert Zemeckis", "Directed the movie"},
        {"Writer", "Eric Roth", "Adapted the screenplay from the novel"},
        {"Composer", "Alan Silvestri", "Created the musical score"}
    };
%>

<%-- 
Rashai Robertson
CSD 430
June 14, 2026
 --%>

<!DOCTYPE html>
<html>
<head>
    <title>Movie Record JSP Page</title>
    <link rel="stylesheet" href="styles.css">
</head>

<body>

    <h1>Movie Record: <%= movieTitle %></h1>

    <p>
        This JSP displays information about one movie I enjoyed watching.
        The data is organized into topical categories such as actors, director,
        writer, and composer.
    </p>

    <h2>Record Description</h2>

    <p>
        Each record in the table contains information related to the movie.
        The table includes the category, person’s name, and their role description.
    </p>

    <h2>Field Descriptions</h2>

    <ul>
        <li><strong>Category:</strong> The type of movie information being shown.</li>
        <li><strong>Name:</strong> The person connected to the movie.</li>
        <li><strong>Description:</strong> A short explanation of the person’s role.</li>
    </ul>

    <h2>Movie Data Table</h2>

    <table>
        <tr>
            <th>Record #</th>
            <th>Category</th>
            <th>Name</th>
            <th>Description</th>
        </tr>

        <%
            /*
                This loop displays each movie record inside the HTML table.
                The HTML tags remain outside the Java Scriptlet sections.
            */
            for (int i = 0; i < movieRecords.length; i++) {
        %>

        <tr>
            <td><%= i + 1 %></td>
            <td><%= movieRecords[i][0] %></td>
            <td><%= movieRecords[i][1] %></td>
            <td><%= movieRecords[i][2] %></td>
        </tr>

        <%
            }
        %>

    </table>

</body>
</html>