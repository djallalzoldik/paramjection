#!/bin/bash

#color
red=`tput setaf 1`
green=`tput setaf 2`
reset=`tput sgr0`
white=`tput setaf 7`
blue=`tput setaf 4`
yellow=`tput setaf 3`
black=`tput setaf 0`

bg_white=`tput setab 7`
bg_red=`tput setab 1`
bg_green=`tput setab 2`
bg_yellow=`tput setab 3`
bg_blue=`tput setab 4`
bg_magenta=`tput setab 5`



#varibles
# whitelist array for -k argument
declare -a arrfiles=("ssrf" "idor" "redirect" "rce" "lfi" "xss" "isql")

# function for urlencode 
urlencode() {
    # urlencode <string>
    local length="${#1}"
    for (( i = 0; i < length; i++ )); do
        local c="${1:i:1}"
        case $c in
            [a-zA-Z0-9.~_-]) printf "$c" ;;
            *) printf '%%%02X' "'$c"
        esac
    done
}

#urldecode function
urldecode() {
    # urldecode <string>

    local url_encoded="${1//+/ }"
    printf '%b' "${url_encoded//%/\\x}"
}




echo "$blue
 ______                          _                   _
(_____ \                        (_)              _  (_)            
 _____) )____  ____ _____ ____   _ _____  ____ _| |_ _  ___  ____  
|  ____(____ |/ ___|____ |    \ | | ___ |/ ___|_   _) |/ _ \|  _ \ 
| |    / ___ | |   / ___ | | | || | ____( (___  | |_| | |_| | | | |
|_|    \_____|_|   \_____|_|_|_|| |_____)\____)  \__)_|\___/|_| |_|
                              (__/                                 $bg_white By: Fekirine Djallal $reset  

"


# Help                                                                         #
################################################################################
Help()
{
   # Display Help
   echo "Usage: 
   paramjection [flags]"
   echo
   echo "   -k idor,xss,all...etc    Kind which target params you want for example 
              if you want to inject in ssrf params use -k ssrf ,
              if you want to target all the params (xss,ssrf,idor...) use -k all  
			  "
   
   echo "   -c collaborator    Use your collaborator like https://webhook.com,
   		      or cebj2b08d3i9vaasv290gj4jaeb446m59.oast.site 
		      you can use it in (ssrf,redirect) 
			  "
   echo "   -w Canary   Choose your own word you can use it in (xss, idor of -f find file)
   "
   echo "   -l List     Choose your urls list
   "
   echo "   -p payload list    Choose your payload list you can use it in (rce,isql,lfi)
   "
   echo "   -o output   
   "
   echo "   -f You can find special param 
    "
   echo "   -v true    use verbose
   "
   echo "   -h     Print this Help.
   "
}

################################################################################
#####################################################################


# loop on the arguments
	while getopts k:c:f:w:l:v:o:p:h flag
	do	
    	case "${flag}" in
		
        	k) file="${OPTARG}";;
        	c) colab="${OPTARG}";;
        	w) can="${OPTARG}";;
        	l) list="${OPTARG}";;
			o) output="${OPTARG}";;
			p) payload="${OPTARG}";;
			f) prm="${OPTARG}";;
			v) verb="${OPTARG}";;
			h) Help
			   exit;;
			\?) 
         		echo "Error: Invalid option"
         		exit;;
        
    	esac
		
	done


# encode value of param when called!
			
				
				function .encodeparam() {
							
							if [[ $ans = "y" ]]; then										  
									
										eparam=(`urlencode  "$1"`)													
							fi 
				}


#function for temprory files in db/ looping on urlslist and filtering and put it in temprory file in db/file-result.txt
			function .db() {
				 echo "${myArray[$1]}" | sed "s/$pa=[^&]*/$pa=$eparam/g" >> "db/"$2"-result.txt"
       			 echo "[ $white $file $green$reset ]${myArray[$1]}" | sed "s/$pa=[^&]*/$pa=$bg_magenta$eparam$reset/g"
			}

			
#check if there custom word list from the user
  	if [ ! -z "$list" ]; then
   	 urls="$list"
   	else
	  urls="urls.txt"
  	fi

#it some time whene try to reading list and put in array
if [[ -f "$url" ]] || [[ -f "$list" ]]; then
		echo "$bg_yellow Reading Your List if your list Big this will take time :)$reset"		
fi

#put userlist in array
declare -a myArray
myArray=(`cat "$urls"`)
tlen=${#myArray[@]}
echo "There are $tlen link in your list  will looking on it,"


#check if there are old files and try to delete them
	if [[ -f "temp" ]]; then
		rm "temp" 
	fi  
	if [[ -f "db"/$file"-result.txt" ]]; then
	  rm "db"/$file"-result.txt"
	fi

#this for -f find params
if [ ! -z $prm ]; then

				echo -n "Do You Want to  use URLencode ? n/y : "
				read ans
	#looping in the list 
	for (( t = 0 ; t < ${tlen}; t++))
			do
				#try to find the param wich mentioned by user
		   		if [[ " ${myArray[$t]} "  == *"$prm="* ]]; then
		   				pa="$prm"
						eparam="$can"
						if [[ $ans = "y" ]]; then
							.encodeparam "$can"
						fi
						file="$prm"
						if [ ! -z $output ]; then
							file=$output
						fi
						.db $t $file
						
						
		   		fi

			done
			if [[ -f "db"/$file"-result.txt" ]]; then
	  			cat "db/"$file"-result.txt" | sort -u > $file".txt"
				echo $bg_green$black"successfully completed here your list >> $file.txt "$reset
				rm "db/"$file"-result.txt" 
			else
			   echo "THIS PARAM NOT FOUND  = $file"
			fi

#when -f mode not active			
elif [ -z $prm ]; then

				echo -n "Do You Want to  use URLencode ? n/y : "
				read ans

		#looping on arrfiles
		for d in "${arrfiles[@]}"
    		do
				
				if [ "$answer" = "n" ]; then
					skip="true"
					break	
				fi
		
        		#check if -k argument have value = "all", This will looping on all arrfiles
				if [[ $file == "all" ]]; then
		    		x="all"
	        		file=$d	
					if [[ -f "db"/$d"-result.txt" ]]; then
	  					rm "db"/$d-result.txt
					fi
			
	    		fi
		   


				#check if value of -k argument is not empty and is one from the whitelist in arrfiles array	
				if [ ! -z $file ] &&  [[ $file = $d ]]; then

					#this loop for list or urls
					for (( i = 0 ; i < ${tlen}; i++))
			     
						do		
							#check if continue without some options
							if [ "$answer" = "n" ]; then
								break	
							fi

							# if verbose is = true , then this command will work
							if [ "$verb" = "true" ]; then
								echo "Looking On link $i in list [$list]"
							fi

							#this grep special params and put in array 
  							declare -a arr2
  							arr2=(`cat "params/$file.txt"`)
							len2=${#arr2[@]}

							#this will looping on the params 
  							for(( b = 0; b < ${len2}; b++))
  								do      

    									pa="${arr2[$b]}"   				 
    									if [[ " ${myArray[$i]} "  == *"$pa="* ]]; then
    					    				if [ ! -z "$file" ] &&  [[ $file = $d ]]; then
    					      
							  		  		 #ssrf and redirect config || this when the -k equal to ssrf or redirect
 					            				if [ $file = ${arrfiles[0]} ] || [ $file = ${arrfiles[2]} ]; then
 					              
 					               
														f=$file
       						            				if [ -z "$colab" ]; then 
															eparam="collaborator"
       			
       						                 				.db $i $f

										     				if [ -z "$answer" ]; then
											    				echo "You are Not Using collaborator! use argument $blue-c$reset for Good Result"
										         				echo -n "Continue Without collaborator? n/y : "
										         				read answer
										     				fi

       						            				elif [[ ! -z $colab ]]; then
												    
										     				if [[ $ans = "y" ]]; then
												    		  	.encodeparam "$colab"
															else
																eparam=(`echo "$colab" | sed 's;/;\\\/;g'`)
						
															fi
															.db $i $f
    					                				fi

												#idor and xss config || this will check if -k eqaul to xss or idor
												elif [[ $file = ${arrfiles[1]} ]] || [[ $file = ${arrfiles[5]} ]]; then
 					              
       						                    		f=$file
       						            				if [ -z "$can" ]; then 
															eparam="Canary"     			
       						                 				.db $i $f
       						             
										     				if [ -z "$answer" ]; then
											     				echo "[$bg_blue notice $reset]You are Not Using Canary! use argument $blue-w$reset for Good Result"
										         				echo -n "Do You Want to  continue with Default Canary ? n/y : "
										         				read answer
										     				fi
       						            				elif [[ ! -z $can ]]; then
															eparam="$can"
										     				if [[ $ans = "y" ]]; then
												      			.encodeparam "$can"
															fi
															.db $i $file
    					                				fi 

												#config isql and lfi and rce || this will check if -k equal to isql or lfi or rce
												elif [[ $file = ${arrfiles[3]} ]] || [[ $file = ${arrfiles[4]} ]] || [[ $file = ${arrfiles[6]} ]]; then
       						                    		f=$file
       						            				if [ -z "$payload" ]; then 
                                                   		declare -a arr3
  					                               		arr3=(`cat "payloads/"$file"_payloads.txt"`)
					                               		len3=${#arr3[@]}
                                                   
												   		#looping in Default payloads
 					                              		 for(( n = 0; n < ${len3}; n++))
  						                                		do 

																			if [ -z "$answer" ]; then
											     		                		echo "[$bg_blue notice $reset]You are Not Using payload list! use argument $blue-p$reset for Good Result"
										         		                		echo -n "Do You Want to  continue with Default payload list ? n/y : "
										         		                		read answer
										     		                		fi
                                                                    		inject="${arr3[$n]}"
																				eparam="$inject"
										     		                			if [[ $ans = "y" ]]; then
												      								.encodeparam "$inject"
																				fi
																				if [[ $answer = "n" ]]; then										  
																					break
																				fi
																				.db $i $f
                                                        		done
       						            				elif [ ! -z $payload ]; then
                                                    		declare -a arr4
  					                                		arr4=(`cat "$payload"`)
					                                		len4=${#arr4[@]}
                                                   
 					                                		for(( r = 0; r < ${len4}; r++))
															#looping in user payloads
  						                                		do
																		inj="${arr4[$r]}"						
																		eparam="$inj"
										     		            		if [[ $ans = "y" ]]; then
												      						.encodeparam "$inj"
																		fi
																		if [[ $answer = "n" ]]; then										  
																			break
																		fi
																		.db $i $f
                                                        		done
    					                				fi 

												fi 
    					        
											fi
					      
   									fi
								
										#function of answer to continue or break
										if [[ $answer = "n" ]]; then										  
											break
										fi
 								done 					 	
						done
				

						#function get stored data from db file and make some handling
						function .catfiles () {
					
							if [[ -f "db"/$f"-result.txt" ]]; then
								cat "db"/$f"-result.txt" | sort -u
	  							rm "db"/$f"-result.txt"
							fi
  			    		} 

						# if -k = "all" and the user choose -o argument
						if [ ! -z $output ] && [[ $x = "all" ]]; then					
							.catfiles  >> "temp"					
							cat "temp" | sort -u > $output

						# if -k all and there are NO output from the user 
			    		elif [ -z $output ] && [[ $x = "all" ]]; then
					  		.catfiles  >> "temp"
					  		cat "temp" | sort -u > $x".txt"

						# if -k not "all" and there are some output from the user 
			    		elif [ ! -z $output ] && [[ ! $x = "all" ]]; then
				      		.catfiles  > $output
					  		echo $bg_green$black"successfully completed here your list >> $output "$reset

						# if no one from preveiws condition then do this command
						else
				   			.catfiles > $f"-res.txt"				  
				   			echo $bg_green$black"successfully completed here your list >> $f-res.txt"$reset
						fi

				fi
				#check if the argument -k have value all , to make looping on all whitelist in arrfiles
				if [[ $x = "all" ]]; then
		  			file="all"
				fi
    
			done	
fi				
				# handling the output when using all option in (-k all)
				if [[ $skip = "true" ]]; then
				   echo "You logout "
				elif [ ! -z $output ] && [[ $x = "all" ]]; then
					echo $bg_green$black"successfully completed here your list >> $output "$reset

			    elif [ -z $output ] && [[ $x = "all" ]]; then
					echo $bg_green$black"successfully completed here your list >> $x.txt"$reset
				fi

	
		


