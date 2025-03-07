<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!-- c:out ; c:forEach etc. --> 
<%@ taglib prefix = "c" uri = "http://java.sun.com/jsp/jstl/core" %>
<!-- Formatting (dates) --> 
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"  %>
<!-- form:form -->
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<!-- for rendering errors on PUT routes -->
<%@ page isErrorPage="true" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>MuseScribe Sign In</title>
    <link rel="stylesheet" href="/CSS/login.css"> 
</head>
<body>

	<!-- TODO:	
	
-Add routes and functionality to form
-Change logo to our MuseScribe official logo
-Phase our static CSS, make switch to full Tailwind
-Make third party sign in functional and add route
-Connect form attributes to user login models
-Set up service for login and registration
-Secure routes
	
	 -->

    <div class="container">
            <div class="col-1">
                <div id="login-logo">
                    <img src="/IMGS/musical-note-svgrepo-com.svg" alt="login-logo">
                </div>
                <div id="slogan">
                    <p>MuseScribe, Music Transcription Made Easy.</p>
                </div>
            </div>
            <div class="col-2">
                <div>
                    <h2>Sign In</h2>
                </div>
                <!-- *******************ADD INPUT VALIDATION FOR USERNAME AND PASSWORD******************* -->
                <div id="form">
                    <form:form>
                        <div class="form-element">
                            <label>Email:</label>
                            <input type="email" placeholder="youraddress@email.com"></input>
                        </div>
                        <div class="error-container"></div>
                        <div class="form-element">
                            <label>Password:</label>
                            <input type="password" placeholder="password456"></input>
                        </div>
                        <div class="error-container"></div>

                        <div id="login-btn">
                            <input id="submit-btn" type="submit" value="Login">
                        </div>
                    </form:form>
                </div>
                <div id="third-party-login">
                    <!-- *******************CLICKING ON THE IMAGE NEEDS TO MAKE AN API CALL TO THE GOOGLE AUTHENTICATION SERVICE******************* -->
                <a href="#">
    				<img src="/IMGS/colorGoogleIcon.png" alt="Google Logo" width="300">
				</a>
                </div>
                <div id="form-extras">
                    <!-- *******************NEEDS TO REDIRECT USER TO THE "FORGOT PASSWORD" PAGE******************* -->
                    <div>
                    <!-- Add route to account recovery page -->
                        <a href="#">Forgot Password?</a>
                    </div>
                    <!-- *******************NEEDS TO REDIRECT USER TO THE "REGISTRATION" PAGE******************* -->
                    <!-- Add route to registration page -->
                    <p>Don't have an account already? <a href="#">Sign up now!</a></p>
                </div>
            </div>
    </div>
</body>
</html>