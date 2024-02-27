<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Shopkeeper Registration - Bachu's Grocery Store</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f4;
            margin: 0;
            padding: 0;
            color: #333;
        }

        h1 {
            text-align: center;
            padding: 20px;
            font-size: 28px;
        }

        .container {
            max-width: 600px;
            margin: 20px auto;
            background-color: #fff;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        }

        label {
            font-weight: bold;
        }

        input[type="text"],
        input[type="tel"],
        input[type="email"],
        input[type="password"] {
            width: 100%;
            padding: 10px;
            margin: 5px 0;
            border: 1px solid #ccc;
            border-radius: 4px;
        }

        button[type="submit"] {
            background-color: #007bff;
            color: #fff;
            padding: 10px 20px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
        }

        button[type="submit"]:hover {
            background-color: #0056b3;
        }

        /* Header styling */
        header {
            background-color: #007bff;
            color: #fff;
            padding: 10px 0;
            text-align: center;
            font-size: 24px;
            font-weight: bold;
        }

        center {
            text-align: center;
        }
 .footer-content {
            display: flex;
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
    <h1>Shopkeeper Registration</h1>
    <div class="container">
        <form action="ShopkeeperRegistrationServlet" method="post">
            <label for="FirstName">First Name</label>
            <input type="text" name="FirstName" placeholder="First Name" required><br>
            <label for="LastName">Last Name</label>
            <input type="text" name="LastName" placeholder="Last Name" required><br>
               <label for="PhoneNumber">Phone number</label>
               <input type="tel" name="PhoneNumber" pattern="\d{10}" title="Phone number must be a 10-digit number" placeholder="Phone Number" required><br>
            <label for="Email">Email</label>
            <input type="email" name="Email" placeholder="Email" required><br>
            <label for="Password">Password</label>
            <input type="password" name="Password" required><br>
            <label for="Address">Address</label>
            <input type="text" name="Address" placeholder="Address" required><br>
            <button type="submit">Register</button>
        </form>
    </div>
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
         function validateForm() {
             var firstName = document.getElementById("FirstName").value;
             var lastName = document.getElementById("LastName").value;
             var phoneNumber = document.getElementById("PhoneNumber").value;
             var email = document.getElementById("Email").value;
             var password = document.getElementById("Password").value;
             var address = document.getElementById("Address").value;

             // Simple validation: Check if any field is empty
             if (!firstName || !lastName || !phoneNumber || !email || !password || !address) {
                 alert("Please fill out all fields.");
                 return false;
             }



             return true; // Form submission will proceed if all checks pass.
         }
     </script>
</body>
</html>
