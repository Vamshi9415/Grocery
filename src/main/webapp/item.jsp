<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*, java.io.*, java.util.Base64" %>
<%@ page import="java.sql.Connection, java.sql.DriverManager, java.sql.PreparedStatement, java.sql.ResultSet, java.sql.SQLException, java.sql.Blob" %>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Bachu's Grocery Store</title>
    <style>
        /* Reset default styles */
        body, h1, h2, p, input, label, button {
            margin: 0;
            padding: 0;
        }


    a {
        display: inline-block;
        padding: 10px 20px;
        background-color: #333;
        color: #fff;
        text-decoration: none;
        border-radius: 5px;
        font-weight: bold;
        transition: background-color 0.3s;
    }

    a:hover {
        background-color: #555;
    }
        body {
            font-family: 'Arial', sans-serif;
            background-color: #f4f4f4;
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            color: #333;
        }

        header {
            background-color: #007bff;
            color: #fff;
            text-align: center;
            padding: 40px;
            font-size: 28px;
            font-weight: bold;
        }

        center {
            text-align: center;
            margin: 20px;
        }

        h2 {
            color: #333;
            font-size: 24px;
            margin: 20px 0;
        }

        /* Container for forms */
        .form-container {
            max-width: 600px;
            margin: 20px auto;
            background-color: #fff;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        }

        /* Radio buttons */
        input[type="radio"] {
            margin-right: 5px;
        }

        /* Form styling */
        form {
            display: none;
        }

        /* Initially show the selected form */
        #addRadio:checked ~ #addForm,
        #updateRadio:checked ~ #updateForm {
            display: block;
        }

        input[type="text"],
        input[type="email"],
        input[type="file"],
        input[type="password"],
        input[type="tel"],input[type="number"]
        {
            width: 100%;
            padding: 10px;
            margin: 5px 0;
            border: 1px solid #ddd;
            border-radius: 4px;
            box-shadow: 0 0 5px rgba(0, 0, 0, 0.1);
        }

        label {
            font-weight: bold;
            margin-top: 10px;
        }

        /* Button styling */
        button {
            background-color: #4CAF50;
            color: white;
            padding: 10px 15px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
        }

        button:hover {
            background-color: #45a049;
        }

        /* Logout button */
        .logout-button {
            background-color: #e74c3c;
        }

        .logout-button:hover {
            background-color: #c0392b;
        }

        /* Responsive styling */
        @media screen and (max-width: 768px) {
            .form-container {
                width: 80%;
            }

            /* Initially hide the update form */
            #updateForm {
                display: none;
            }
        }
         .footer-content {
                    display: flex;
                    background-color:black;
                    flex-wrap: wrap;
                    justify-content: space-between;
                }

                .copyright, .contact {
                    flex: 1;
                    margin: 10px;
                }

                .social-links {
                    flex: 1;
                }

                .social-links a {
                    text-decoration: none;
                    margin: 0 10px;
                    color: #fff;
                }

    </style>
</head>
<body>
<header>Welcome to Bachu's Grocery Store</header>

<center>
    <!-- Radio buttons for Add and Update -->
    <input type="radio" id="addRadio" name="formType" checked>
    <label for="addRadio">Add</label>

    <input type="radio" id="updateRadio" name="formType">
    <label for="updateRadio">Update</label>

    <form id="addForm" action="ShopkeeperAddServlet" method="post" enctype="multipart/form-data" class="form-container">
        <h2>Add Items</h2>
        <!-- Your form inputs go here -->
        <label for="itemName">Item Name</label>
        <input type="text" name="itemName" required><br>
        <label for="itemDescription">Item Description</label>
        <input type="text" name="itemDescription" required><br>
        <label for="imageData">Image Data</label>
        <input type="file" name="imageData" required><br>
        <label for="itemQuantity">Item Quantity</label>
        <input type="number" min ="1" name="itemQuantity" required><br>
        <label for="shopkeeperEmail">Shopkeeper Email</label>
        <input type="email" name="shopkeeperEmail" required><br>
        <label for="itemPrice">Price</label>
        <input type="text" step="0.01" name="itemPrice" required><br>
        <button type="submit" id="addButton">Add</button>
    </form>

    <form id="updateForm" action="ShopkeeperUpdateServlet" method="post" enctype="multipart/form-data" class="form-container">

        <label for="updateItemName">Item Name</label>
        <input type="text" name="updateItemName" required><br>
        <label for="updateItemQuantity">Item Quantity</label>
        <input type="number" min ="1" name="updateItemQuantity" required><br>

        <button type="submit" id="updateButton">Update</button>
    </form>
</center>
<center>
    <button class="logout-button" onclick="location.href='LogoutServlet'">Logout</button>
</center>
<center>
    <a href="retrieve.html">Retrieve Information</a>
</center>
<center>
    <a href="retrieveBuyer.jsp">Retrieve Information as Buyer</a>
</center>




<footer class="special-footer">
            <div class="footer-content">
                <div class="copyright">
                    &copy; 2023 Bachu's Grocery Store'. All rights reserved.
                </div>
                <div class="contact">
                    Contact us at: contact@bachugrocery.com
                </div>
                <div class="social-links">
                    <a href="facebook.com"> Facebook</a>
                    <a href="Twitter.com"> Twitter</a>
                    <a href="instagram.com">Instagram</a>
                </div>
            </div>
        </footer>

<script>
    // Get references to the forms and buttons
    const addForm = document.getElementById("addForm");
    const updateForm = document.getElementById("updateForm");
const retrieveForm = document.forms["retreive"];
    // Get references to the radio buttons
    const addRadio = document.getElementById("addRadio");
    const updateRadio = document.getElementById("updateRadio");

    // Hide the update form initially
    updateForm.style.display = "none";

    // Add event listeners to show/hide forms based on radio button selection
    addRadio.addEventListener("change", function () {
        addForm.style.display = "block";
        updateForm.style.display = "none";
    });

    updateRadio.addEventListener("change", function () {
        addForm.style.display = "none";
        updateForm.style.display = "block";
    });
</script>
</body>
</html>
