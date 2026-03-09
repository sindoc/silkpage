<?php
// ----------------------------------------------------------------------------
//      Init.
// ----------------------------------------------------------------------------
$ok=0;
$ko=0;
$notext=0;
$komail=0;
// ----------------------------------------------------------------------------
//      Function Definitions
// ----------------------------------------------------------------------------

function validate_email($email)
{
   // Create the syntactical validation regular expression
   $regexp = "^([_a-z0-9-]+)(\.[_a-z0-9-]+)*@([a-z0-9-]+)(\.[a-z0-9-]+)*(\.[a-z]{2,4})$";
   
   // Presume that the email is invalid
   $valid = 0;

   // Validate the syntax
   if (eregi($regexp, $email))
   {
      list($username,$domaintld) = split("@",$email);
      // Validate the domain
      if (getmxrr($domaintld,$mxrecords))
         $valid = 1;
   } else {
      $valid = 0;
   }
   return $valid;
}

// ----------------------------------------------------------------------------
//      Main
// ----------------------------------------------------------------------------

$name=$_POST['name'];
$email=$_POST['email'];
$url=$_POST['url'];
$comment=$_POST['comment'];

if(!validate_email($email)) {
  $komail=1;
}

if ((empty($email)) OR 
    (empty($comment))) {
  $notext=1;
} 

if ($komail!=1 AND $notext!=1) {

  $message = "Name: ";
  $message .=$name;
  $message .="\nE-mail: ";
  $message .=$email;
  $message .="\nURL: ";
  $message .=$url;
  $message .="\nComment: ";
  $message .=$comment;
  $RECIPIENT_EMAIL .="\n";
  $subject .="\n";
  $message .="\n";
  if (mail('silkpage@markupware.com', $subject,$message)) {
    $ok=0 ;
    header ("Location:./../site/feedback/sent.html");
    exit();
  }
  else {
    $ko=1;
  }
}
header ("Location:./../site/feedback/index.php?ok=$ok&ko=$ko&notext=$notext&komail=$komail");
?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
    "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta content="HTML Tidy for Java (vers. 2009-08-01), see jtidy.sourceforge.net" name="generator" />
<title></title>
</head>
<body>
</body>
</html>
