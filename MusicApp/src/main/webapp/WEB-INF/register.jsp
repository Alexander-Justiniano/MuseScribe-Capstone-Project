<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!-- c:out ; c:forEach etc. --> 
<%@ taglib prefix = "c" uri = "http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<!-- for rendering errors on PUT routes -->
<%@ page isErrorPage="true" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Register</title>
    <link rel="stylesheet" href="/CSS/register.css">
</head>
<body>
    <div class="container">
        <div id="col-1">
        	<div id="goBack" >
        		<a href="/" class="goBack">&lt; Go Back</a>
        	</div>
            <div id="logo">
                <img src="/IMGS/museScribe-logo.svg" alt="plain logo">
            </div>
                <!-- *******************ADD INPUT VALIDATION ERRORS FOR ALL FORM FIELDS******************* -->
            <div id="form">
                <div id="elements-container">
                	<form:form method="post" action="/register" modelAttribute="newUser">
	                    <div class="form-element">
	                        <form:label path="name">Name:</form:label>
	                        <form:input type="text" path="name" placeholder="John Doe"></form:input>
	                    </div>
	                    <div class="error-container"><form:errors path="name" class="css-error"/></div>
	                    <div class="form-element">
	                        <form:label path="email">Email:</form:label>
	                        <form:input type="email" path="email" placeholder="youremail@address.com"></form:input>
	                    </div>
	                    <div class="error-container"><form:errors path="email" class="css-error"/></div>
	                    <div class="form-element">
	                        <form:label path="password">Password:</form:label>
	                        <form:input type="password" path="password" placeholder="password456"></form:input>
	                    </div>
	                    <div class="error-container"><form:errors path="password" class="css-error"/></div>
	                    <div class="form-element">
	                        <form:label path="confirm">Confirm Password:</form:label>
	                        <form:input type="password" path="confirm" placeholder="password456"></form:input>
	                    </div>
	                    <div class="error-container"><form:errors path="confirm" class="css-error"/></div>
                	<div id="form-extras">
                	<!-- Sign Up with Google -->
                    	<h3>Sign up with:</h3>
			                <div id="third-party-login" class="mb-5">
					            <a 
					              class="flex flex-row items-center mx-auto justify-center w-1/2 py-2 gap-2 bg-white border-2 rounded border-gray-400" 
					              href="/oauth2/authorization/google"
					            >
					              <img src="/IMGS/colorGoogleIcon.png" alt="Google Logo" width="100"> 
					            </a>
					        </div>
                    	<div>
                        	<input id="submit-btn" type="submit" value="Create Account">
                    	</div>
                    </div>
                	</form:form>
                </div>
             </div>
        </div>
    </div>
</body>
</html>