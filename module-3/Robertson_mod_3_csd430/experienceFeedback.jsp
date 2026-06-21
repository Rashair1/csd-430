<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<!--
    Rashai Robertson
    CSD430
    Module 3: Assignment 3.2

    This JSP page collects customer feedback regarding their dining experience.
    The form gathers information about the customer, meal ordered, service rating,
    recommendation status, and additional comments.
-->

<!DOCTYPE html>
<html>
<head>
    <title>Restaurant Feedback</title>
    <link rel="stylesheet" href="styles.css">
</head>

<body>

<div class="container">

    <h1>Restaurant Feedback</h1>

    <p class="description">
        Please tell us about your dining experience.
    </p>
    <!-- Begin Asking Questions -->
    <form action="displayAnswers.jsp" method="post">

        <label for="name">Name:</label>
        <input type="text" id="name" name="name" required>

        <label for="email">Email Address:</label>
        <input type="email" id="email" name="email" required>

        <label for="meal">Meal Ordered:</label>
        <select id="meal" name="meal">
            <option>Burger</option>
            <option>Steak</option>
            <option>Chicken Alfredo</option>
            <option>Salad</option>
            <option>Fish Dinner</option>
        </select>

        <label>Service Rating:</label>

        <div class="radio-group">
            <input type="radio" name="rating" value="Excellent" required> Excellent
            <input type="radio" name="rating" value="Good"> Good
            <input type="radio" name="rating" value="Fair"> Fair
            <input type="radio" name="rating" value="Poor"> Poor
        </div>

        <div class="checkbox-group">
            <input type="checkbox" name="recommend" value="Yes">
            I would recommend this restaurant.
        </div>

        <label for="comments">Additional Comments:</label>
        <textarea id="comments" name="comments" rows="5"></textarea>

        <input type="submit" value="Submit Feedback">

    </form>

</div>

</body>
</html>