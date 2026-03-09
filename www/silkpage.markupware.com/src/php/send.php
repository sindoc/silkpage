<?php
// ----------------------------------------------------------------------------
// 	Init.
// ----------------------------------------------------------------------------
$ok=0;
$ko=0;
$notext=0;
$komail=0;
// ----------------------------------------------------------------------------
// 	Function Definitions
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
// 	Main
// ----------------------------------------------------------------------------

$name=$_POST['name'];
$subject=$_POST['subject'];
$mail=$_POST['mail'];
$category=$_POST['category'];
$comment=$_POST['comment'];

if ((empty($name)) OR 
    (empty($subject)) OR 
    (empty($mail)) OR 
    (empty($comment))) {
	$notext=1;
} 

if(!validate_email($mail)) {
	$komail=1;
}

if ($komail!=1 AND $notext!=1) {

  $message = "Name: ";
  $message .=$name;
  $message .="\nCategory: ";
  $message .=$category;
  $message .="\nSubject: ";
  $message .=$subject;
  $message .="\nE-mail: ";
  $message .=$mail;
  $message .="\nComment: ";
  $message .=$comment;
  $subject .="\n";
  $message .="\n";
  if (mail('silkpage@markupware.com', $subject,$message)) {
    $ok=0; 
    header ("Location:message-sent.html");
    exit();
  }
  else {
    $ko=1;
  }
}

header ("Location:contact.php?ok=$ok&ko=$ko&notext=$notext&komail=$komail");
?>
