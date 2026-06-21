<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<!--
    Rashai Robertson
    CSD430
    Module 3: Assignment 3.2

    This JSP page displays the submitted feedback to the customer.
-->

<%
    String name = request.getParameter("name");
    String email = request.getParameter("email");
    String meal = request.getParameter("meal");
    String rating = request.getParameter("rating");
    String recommend = request.getParameter("recommend");
    String comments = request.getParameter("comments");

    if(recommend == null){
        recommend = "No";
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Restaurant Feedback Results</title>
    <link rel="stylesheet" href="styles.css">
</head>

<body>

<div class="container">

    <h1>Restaurant Feedback Results</h1>

    <p class="description">
        Thank you for your feedback! The information you provided is below.
    </p>

    <!-- Shows Submitted Data from experienceFeedback in a Table -->
    <table>
        <tr>
            <th>Field Description</th>
            <th>Submitted Data</th>
        </tr>

        <tr>
            <td>Name</td>
            <td><%= name %></td>
        </tr>

        <tr>
            <td>Email Address</td>
            <td><%= email %></td>
        </tr>

        <tr>
            <td>Meal Ordered</td>
            <td><%= meal %></td>
        </tr>

        <tr>
            <td>Service Rating</td>
            <td><%= rating %></td>
        </tr>

        <tr>
            <td>Would Recommend Restaurant</td>
            <td><%= recommend %></td>
        </tr>

        <tr>
            <td>Additional Comments</td>
            <td><%= comments %></td>
        </tr>
    </table>

    <a href="restaurantFeedback.jsp">Submit Another Review</a>

</div>

</body>
</html>