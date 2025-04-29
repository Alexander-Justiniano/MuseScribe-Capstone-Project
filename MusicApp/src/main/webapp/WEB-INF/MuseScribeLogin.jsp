<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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

<div class="h-screen flex justify-center items-center">
    <div class="flex justify-between p-10">
      
      <!-- left logo & slogan -->
      <div class="w-1/2 bg-grey-500 p-5 flex flex-col justify-center items-center text-center mr-40 rounded">
          <div id="login-logo">
              <img src="/IMGS/musescribe-logo.svg" alt="login-logo">
          </div>
          <div id="slogan" class="mt-4">
              <p>MuseScribe, Music Transcription Made Easy.</p>
          </div>
      </div>

      <!-- right sign-in box -->
      <div class="w-1/2 bg-gray-100 flex flex-col p-4 rounded shadow-lg">
        
        <div class="mb-5">
            <h2 class="text-2xl text-center">Sign In</h2>
        </div>

        <!-- ✕ error / ✓ logout messages -->
        <c:if test="${param.error != null}">
          <div class="text-red-600 mb-4 text-center">Invalid email or password.</div>
        </c:if>
        <c:if test="${param.logout != null}">
          <div class="text-green-600 mb-4 text-center">You’ve been logged out.</div>
        </c:if>

        <!-- form-login -->
        <div id="form">
          <form action="/login" method="post">
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>

            <div class="form-element">
                <label>Email:</label>
                <input 
                  class="px-2 rounded" 
                  type="email" 
                  name="username" 
                  placeholder="youraddress@email.com" 
                  required
                />
            </div>
            <div class="error-container"></div>

            <div class="form-element">
                <label>Password:</label>
                <input 
                  class="px-2 rounded" 
                  type="password" 
                  name="password" 
                  placeholder="password456" 
                  required
                />
            </div>
            <div class="error-container"></div>

            <div id="login-btn">
                <input id="submit-btn" type="submit" value="Login">
            </div>
          </form>
        </div>

        <hr class="border-gray-400 my-5">

        <!-- google oauth -->
        <div id="third-party-login" class="mb-5">
            <a 
              class="flex flex-row items-center mx-auto justify-center w-1/2 py-2 gap-2 bg-white border-2 rounded border-gray-400" 
              href="/oauth2/authorization/google"
            >
              <img src="/IMGS/colorGoogleIcon.png" alt="Google Logo" width="100"> 
              <span>Google Login</span>
            </a>
        </div>

        <div id="form-extras" class="flex flex-col gap-7 mt-5">
          <div>
            <a class="underline" href="/forgotPassword">Forgot Password?</a>
          </div>
          <p>
            Don't have an account already? 
            <a class="underline" href="/register">Sign up now!</a>
          </p>
        </div>

      </div>
    </div>
</div>

</body>
</html>