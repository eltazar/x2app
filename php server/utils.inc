<?php

/**
* Funzioni per il crypt/decrypt del numero di carta di credito
*
* @author Giuseppe Lisanti
*
**/

$path="/Users/peppelisanti/.gnupg";//environment di gpg

$email="peppelisanti@tiscali.it";//chiave
$pwd="pippo";

$lockfilepath="/Users/peppelisanti/.gnupg/lockfile";//path del lockfile

$handle="/Users/peppelisanti/Desktop/per_peppe/file0001";//path del file che conterrà la chiave decriptata

function valueForward($val)  //crypt
{ 
  global $path, $email;
  $output = array();
  $retval = 0;
  putenv("GNUPGHOME=$path");
  
  $command = "echo '$val' | gpg -e -r $email --yes "; 
  exec($command,$output,$retval);
  
  $string = implode("\n",$output);
  $uu = convert_uuencode($string);
  $uu = urlencode($uu);
  return $uu;
}

function valueBackward($c_num) //decrypt
{
  global $path, $lockfilepath, $handle, $pwd;
  
  putenv("GNUPGHOME=$path"); //environment di gpg

  $c_num = ltrim($c_num,"\n");
  $c_num=urldecode($c_num);
  $dd = convert_uudecode($c_num);

  $lock = fopen("$lockfilepath","r+");
  
  while (!flock($lock, LOCK_EX))
    usleep(100);
  if (flock($lock, LOCK_EX))
  { 
  	$uudec = fopen("$handle",'wb');
    fwrite($uudec,$dd);
    fclose($uudec);
    
    $output2 = array();
    
    $command = "gpg -d --passphrase $pwd --quiet --batch $handle";
    $string = exec($command,$output2,$retval);
    
    $c_num = $output2[0];
    flock($lock,LOCK_UN);
 }
  else
    print("valueBackward couldn't get the lock\n");
  fclose($lock);
  return $c_num;
}

?>