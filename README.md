# CritterCrush

## Table of Contents
1. [Overview](#Overview)
2. [Wireframes](#Wireframes)
3. [API Reference](#API_Reference)
4. [App Demo](#App_Demo)

## Overview
### Description
Develop an iOS app for users to take pictures of invasive species of insects in NY, identify them using image recognition and upload reports to an online database. The app will be built for more casual use with extras such as social features and associated rewards for uploading reports.

## Wireframes
<img width="872" alt="Screenshot 2023-02-23 at 3 23 20 PM" src="https://user-images.githubusercontent.com/56377738/221021733-8d9b9651-3682-4d67-bcf8-11ec70a17b88.png">

### Prototype
<img src="http://g.recordit.co/O2gJGXhWig.gif" width="300" height="600">

## API Reference
|        API        |    Description   | Request Parameters | Response Body |
| ----------------- | ---------------- | ----------------- | ------------- |
| GET /api/reports      | Returns list of reports | None | List of Report objects |
| GET /api/users/login | Recieve auth token for user from username and password | Username, Password | Auth token |
| POST /api/users/register | Register new user into database | Username, Password, Email | Auth token |
| GET /api/users/verifylogin | Verify auth token | Username | Boolean (true if token is valid) |

### App_Demo
<p>SignUp Screen<p>
<img src="https://github.com/EMagHunter/CritterCrush/assets/80727432/beaa4689-126e-4600-b239-5f1959dd7de6" width="150" height="300">
  
<p>Login Screen<p>
<img src="https://github.com/EMagHunter/CritterCrush/assets/80727432/68c54b45-7c2c-4853-866b-d3917ade1d65" width="150" height="300">
  
<p>Species Screen<p>
<img src="https://github.com/EMagHunter/CritterCrush/assets/80727432/fa7fb100-68f4-41cb-a68c-487467a03783" width="150" height="300">

<p>Map Screen<p>
<img src="https://github.com/EMagHunter/CritterCrush/assets/80727432/c977aa08-37c2-4837-a4c0-74f6b47af247" width="150" height="300">

<p>Profile Screen<p>
<img src="https://github.com/EMagHunter/CritterCrush/assets/80727432/aa8eb991-2f49-4f92-8b2d-366826fc26d3" width="150" height="300">

<p>Setting Screen<p>
<img src= "https://github.com/EMagHunter/CritterCrush/assets/80727432/3989a615-3663-4c4e-95a9-1ad40c32f9f1" width="150" height="300">
    
<p>Submit Report<p>
<img src="https://github.com/EMagHunter/CritterCrush/assets/80727432/129763f3-1d6c-4c85-9cab-eae31339520f" width="150" height="300">


