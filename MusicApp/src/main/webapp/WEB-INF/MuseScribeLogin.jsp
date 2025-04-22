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
	<link href="https://cdnjs.cloudflare.com/ajax/libs/tailwindcss/2.2.19/tailwind.min.css" rel="stylesheet">
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
<div class="h-screen flex justify-center items-center">
    <div class="flex justify-between p-10">
            <div class="w-1/2 bg-grey-500 p-5 flex flex-col justify-center items-center text-center mr-40">
                <div id="login-logo">
                    <img src="/IMGS/musescribe-logo.svg" alt="login-logo">
                </div>
                <div id="slogan">
                    <p>MuseScribe, Music Transcription Made Easy.</p>
                </div>
            </div>
            <div class="w-1/2 bg-gray-100 flex flex-col p-4 rounded shadow-lg">
                <div class="mb-5">
                    <h2 class="text-2xl text-center">Sign In</h2>
                </div>
                <!-- *******************ADD INPUT VALIDATION FOR USERNAME AND PASSWORD******************* -->
                <div id="form">
                    <form:form>
                        <div class="form-element">
                            <label>Email:</label>
                            <input class="px-2 rounded" type="email" placeholder="youraddress@email.com" />
                        </div>
                        <div class="error-container"></div>
                        <div class="form-element">
                            <label>Password:</label>
                            <input class="px-2 rounded" type="password" placeholder="password456" />
                        </div>
                        <div class="error-container"></div>

                        <div id="login-btn">
                            <input id="submit-btn" type="submit" value="Login">
                        </div>
                    </form:form>
                </div>
				<hr class="border-gray-400 my-5">
                <div id="third-party-login" class="mb-5">
                    <!-- *******************CLICKING ON THE IMAGE NEEDS TO MAKE AN API CALL TO THE GOOGLE AUTHENTICATION SERVICE******************* -->
                    
	                <a class="flex flex-row items-center mx-auto justify-center w-1/2 py-2 gap-2 bg-white border-2 rounded border-gray-400" href="/dashboard">
	    				<img src="/IMGS/colorGoogleIcon.png" alt="Google Logo" width="100"> 
						<span>Google Login</span>
					</a>

                </div>
                <div id="form-extras" class="flex flex-col gap-7 mt-5">
                    <!-- *******************NEEDS TO REDIRECT USER TO THE "FORGOT PASSWORD" PAGE******************* -->
                    <div>
                    <!-- Add route to account recovery page -->
                        <a class="underline" href="#">Forgot Password?</a>
                    </div>
                    <!-- *******************NEEDS TO REDIRECT USER TO THE "REGISTRATION" PAGE******************* -->
                    <!-- Add route to registration page -->

                    <p>Don't have an account already? <a class="underline" href="/register">Sign up now!</a></p>

                </div>
            </div>
    </div>
</div>
</body>
</html>