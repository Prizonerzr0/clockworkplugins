<?php session_start();?>
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <title>Character Update</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="keywords" content=", clockworkwebviewer, clockwork, web viewer, trurascalz, webviewer,">
    <meta name="author" content="Alex Savory">
<meta name="description" content="A web viewer  which is free and provided by Alex Savory">
    <script>
function goBack()
  {
  window.history.back()
  }
</script>

    <!-- Le styles -->
    <link href="assets/css/bootstrap.css" rel="stylesheet">
    <style type="text/css">
      body {
        padding-top: 40px;
        padding-bottom: 40px;
        background-color: #f5f5f5;
      }

      .form-install {
        max-width: 1000px;
        padding: 19px 29px 29px;
        margin: 0 auto 20px;
        background-color: #fff;
        border: 1px solid #e5e5e5;
        -webkit-border-radius: 5px;
           -moz-border-radius: 5px;
                border-radius: 5px;
        -webkit-box-shadow: 0 1px 2px rgba(0,0,0,.05);
           -moz-box-shadow: 0 1px 2px rgba(0,0,0,.05);
                box-shadow: 0 1px 2px rgba(0,0,0,.05);
      }
      .form-install .form-install-heading,
      .form-install .checkbox {
        margin-bottom: 10px;
      }


    </style>
    <link href="../assets/css/bootstrap-responsive.css" rel="stylesheet">

    <!-- HTML5 shim, for IE6-8 support of HTML5 elements -->
    <!--[if lt IE 9]>
      <script src="../assets/js/html5shiv.js"></script>
    <![endif]-->

    <!-- Fav and touch icons -->
    <link rel="apple-touch-icon-precomposed" sizes="144x144" href="../assets/ico/apple-touch-icon-144-precomposed.png">
    <link rel="apple-touch-icon-precomposed" sizes="114x114" href="../assets/ico/apple-touch-icon-114-precomposed.png">
      <link rel="apple-touch-icon-precomposed" sizes="72x72" href="../assets/ico/apple-touch-icon-72-precomposed.png">
                    <link rel="apple-touch-icon-precomposed" href="../assets/ico/apple-touch-icon-57-precomposed.png">
                                   <link rel="shortcut icon" href="../assets/ico/favicon.png">
  </head>
<?php if(!isset($_SESSION['steam_session']) && !isset($_POST['key'])){header("location:mycharacters.php");} ?>
  <body>

    <div class="container">

      <div class="form-install">
        <h2 class="form-install-heading">Updating Ban</h2>
<?php

define("CHANGEME", TRUE);
include('include/globalconfig.php');
include('include/func.php');
$con = mysql_connect($address,$user,$pass);
if (!$con)
  {
  echo('<div class="alert alert-error">' . mysql_error() . '</div>');
  }
else echo('<div class="alert alert-success">Successfully Connected</div>');

mysql_select_db($database, $con);
$key = mysql_real_escape_string($_POST['key']);


$steamid = mysql_real_escape_string($_POST['steamid']);
$unbantime = mysql_real_escape_string($_POST['unbantime']);
$duration = mysql_real_escape_string($_POST['duration']);
$reason = mysql_real_escape_string($_POST['reason']);


$sql = 
"UPDATE  `bans` SET  `_Identifier` =  '$steamid',
`_UnbanTime` =  '$unbantime',
`_Duration` =  '$duration',
`_Reason` =  '$reason' WHERE `_Key` = $key";
mysql_query($sql);

echo "<div class='well'>
<h2>Admin Edit Mode</h2>
$sql
</div>
";
if (mysql_error()==""){ 
echo '<div class="alert alert-success">Ban Updated!</div><br>
<a href="index.php"class="btn btn-large btn-block btn-success">Return to dashboard</a>
';
}
else
echo '<div class="alert alert-error">ERROR - '.mysql_error().'<br>If this keeps happening you should contact the Owner about this!</div><br>';

?>
      </div>


  



<center> &copy Clockwork Web Viewer - Alex Savory</center>
    </div> <!-- /container -->

    <!-- Le javascript
    ================================================== -->
    <!-- Placed at the end of the document so the pages load faster -->
    <script src="../assets/js/jquery.js"></script>
    <script src="../assets/js/bootstrap-transition.js"></script>
    <script src="../assets/js/bootstrap-alert.js"></script>
    <script src="../assets/js/bootstrap-modal.js"></script>
    <script src="../assets/js/bootstrap-dropdown.js"></script>
    <script src="../assets/js/bootstrap-scrollspy.js"></script>
    <script src="../assets/js/bootstrap-tab.js"></script>
    <script src="../assets/js/bootstrap-tooltip.js"></script>
    <script src="../assets/js/bootstrap-popover.js"></script>
    <script src="../assets/js/bootstrap-button.js"></script>
    <script src="../assets/js/bootstrap-collapse.js"></script>
    <script src="../assets/js/bootstrap-carousel.js"></script>
    <script src="../assets/js/bootstrap-typeahead.js"></script>

<script>  
$(function ()  
  { $("#apikeyhelp").popover({html:true,trigger:'hover'});  
  $("#logourlhelp").popover({placement:'right',html:true,trigger:'hover'});  
  $("#featuredcontent").popover({placement:'right',html:true,trigger:'hover'}); 
    $("#urlhelp").popover({placement:'right',html:true,trigger:'hover'});   
  $("#timezonehelp").popover({placement:'right',html:true,trigger:'click'});  
});  
</script>  



  </body>
</html>
