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

#date
dated=$( date +"%m%d%Y%H%M%s")

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
# Help                                                                         #
################################################################################
Help()
{
   # Display Help
   echo "Usage: 
   paramjection [flags]"
   
   echo "   -k idor,xss,all...etc    Kind which target params you want for example 
              if you want to inject in ssrf params use -k ssrf ,
              if you want to target all the params (xss,ssrf,idor...) use -k all  "
   
   echo "   -c collaborator    Use your collaborator like https://webhook.com,
   		      or cebj2b08d3i9vaasv290gj4jaeb446m59.oast.site 
		      you can use it in (ssrf,redirect) "
   echo "   -w Canary   Choose your own word you can use it in (xss, idor of -f find file)"
   echo "   -l List     Choose your urls list"
   echo "   -p payload list    Choose your payload list you can use it in (rce,isql,lfi)"
   echo "   -o output   "
   echo "   -f You can find special param "
   echo "   -v     use verbose"
   echo "   -e    encode the paramaters"
   echo "   -d    decode the paramaters"
   echo "   -d    decode the paramaters"
   echo "   --bE  encodebase64"
   echo "   --bD  decodebase64"
   echo "   -h     Print this Help."
}

################################################################################
#####################################################################

### url encode##7
Encodeurl() {
	ans="y"
	en="y"
}

decodeurl() {
	ans="y"
	en="d"

}

encodebase64func() {
	ans="y"
	en="b"
}

decodebase64func() {
	ans="y"
	en="bd"
}

verbose() {
	v="true"
}

##



# loop on the arguments
	while [ $# -gt 0 ] ; 
	do	
    	case "$1" in

        	-k) file="$2";;
        	-c) colab="$2";;
        	-w) can="$2";;
        	-l) list="$2";;
			-o) output="$2";;
			-p) payload="$2";;
			-f) prm="$2";;
			-v) verbose ;;
			-e) Encodeurl ;;
			-d) decodeurl ;;
			--bE) encodebase64func;;
			--bD) decodebase64func;;
			-h) Help
			    exit;;
			 \?) 
         		 echo "Error: Invalid option"
         		 exit;;
        
    	esac
		shift
		
	done




##

	if [ -t 1 ]; then

		echo "$blue
		 ______                          _                   _
		(_____ \                        (_)              _  (_)            
		 _____) )____  ____ _____ ____   _ _____  ____ _| |_ _  ___  ____  
		|  ____(____ |/ ___|____ |    \ | | ___ |/ ___|_   _) |/ _ \|  _ \ 
		| |    / ___ | |   / ___ | | | || | ____( (___  | |_| | |_| | | | |
		|_|    \_____|_|   \_____|_|_|_|| |_____)\____)  \__)_|\___/|_| |_|
		                              (__/                                 $bg_white By: Fekirine Djallal $reset  

		"
	fi




# encode value of param when called!
			
				
				function .encodeparam() {
							
							if [[ $ans = "y" ]]; then
									if [[ "$equalmultipe" == "true" ]]; then
										eqa="$1=="
									fi

									if [[ $en = "y" ]]; then 
										eparam=(`urlencode  "$1"`)
									elif [[ $en = "d" ]]; then
										eparam=(`urldecode  "$1"`)
										eparam=(`echo "$eparam" | sed 's;/;\\\/;g'`)
									elif [[ $en = "b" ]]; then
									   eparam=(`echo "$1" | base64`)
									elif [[ $en = "bd" ]] && [[ "$eqa" =~ ^([A-Za-z0-9+/]{4})*([A-Za-z0-9+/]{3}=|[A-Za-z0-9+/]{2}==)?$ ]] ; then
									   eparam=(`echo "$1" | base64 --decode --ignore-garbage`)
									   eparam=(`echo "$eparam" | sed 's;/;\\\/;g'`)									
									fi											
							fi 
				}


#function for temprory files in db/ looping on urlslist and filtering and put it in temprory file in db/file-result.txt
			function .db() {


				#if [ "$stand" == "on" ]; then
					if [ -z "$3" ]; then

						echo "$1" | sed "s/$pa=[^&]*/$pa=$eparam/g" >> ~/"paramjection/db/""$2_$dated""-result.txt"
						if [ -t 1 ]; then
							echo "[ $white $file $green$reset ]$1" | sed "s/$pa=[^&]*/$pa=$bg_magenta$eparam$reset/g"
						else	
							echo "$1" | sed "s/$pa=[^&]*/$pa=$eparam/g" #>> "db/""$2_$dated""-result.txt"
						fi


					else
						echo "$1" | sed "s/$pa=[^&]*/$pa=$eparam/g" >> ~/"paramjection/db/""$2_$dated""-result.txt"
						if [ -t 1 ]; then
							echo "[ $white $file $green$reset ]$1" | sed "s/$pa=[^&]*/$pa=$bg_magenta$eparam$reset/g"
						else	
							echo "$1" | sed "s/$pa=[^&]*/$pa=$eparam/g" #>> "db/""$2_$dated""-result.txt"
						fi
					fi

			}

			
#check if there custom word list from the user
  	if [ ! -z "$list" ]; then
   	 urls="$list"
   	else
	  urls=~/"paramjection/urls.txt"
  	fi

#it some time whene try to reading list and put in array
if [ -t 1 ]; then
	if [[ -f "$url" ]] || [[ -f "$list" ]]; then
			echo "$bg_yellow Reading Your List if your list Big this will take time :)$reset"		
	fi
fi


#check if there are old files and try to delete them
	if [[ -f ~/"paramjection/temp" ]]; then
		rm ~/"paramjection/temp" 
	fi  
	if [[ -f ~/"paramjection/db""/$file_$dated""-result.txt" ]]; then
	  rm ~/"paramjection/db"/"$file_$dated""-result.txt"
	fi

#this for -f find params
if [ ! -z $prm ]; then

				
	#looping in the list or looping on standard input

	       

				
  
		findfunction() {
				while [[ $prm = "all" ]]; do
										
										prm=""										
										if [[ $en = "bd" ]] || [[ $en = "d" ]]; then
											if [[ "$line"  =~ "=="{1,} ]]; then
												equalmultipe="true"
											fi
											line=(` echo $line | sed 's/==\{1,\}//g' `)	
										fi
						
									done
				#try to find the param wich mentioned by user
		   		if [[ "$line"  == *"$prm="* ]]; then
		   				pa="$prm"
						cond="&"
						value=(`echo "$line" | sed "s/$pa=[^&]*/$cond/g" | sed "s/.*$pa=//g" | sed "s/&.*//g"`)
						if [ -z "$can" ]; then 
																				
									

									if [[ $ans = "y" ]]; then
										if [[ $en = "bd" ]] || [[ $en = "d" ]]; then											
													.encodeparam "$value"
											else 

													.encodeparam "$can"
										fi
									  	
										
									else
										eparam=(`echo "$value" | sed 's;/;\\\/;g'`)

									fi
									

									
						else
							if [[ $ans = "y" ]]; then

								.encodeparam "$can"
							else

								eparam=(`echo "$can" | sed 's;/;\\\/;g'`)
							fi
							
						fi
						file="$prm"
						if [ ! -z $output ]; then
							file=$output
						else 
							file="all_params_injected"

						fi
							 
							.db $line $file $can
						
						
						
		   		fi

			}
								files=${list--} # POSIX-compliant; ${1:--} can be used either.
								while IFS= read -r line; do 
								  findfunction
								  if [[ $prm = "all" ]]; then
								  	prm="all" 
								  fi

								  
								  
								done < <(cat -- "$files")

			if [[ -f ~/"paramjection/db/""$file""_""$dated""-result.txt" ]]; then
	  			cat ~/"paramjection/db/""$file"_"$dated""-result.txt" | sort -u > "$file""_$dated"".txt"
				echo $bg_green$black"successfully completed here your list >>" "$file""_""$dated.txt "$reset
				rm ~/"paramjection/db/""$file""_""$dated""-result.txt" 
			else
			   echo "THIS PARAM NOT FOUND  = $file"
			fi

#when -f mode not active			
elif [ -z $prm ]; then

				

		#looping on arrfiles
		for d in "${arrfiles[@]}"
    		do
				
				
		
        		#check if -k argument have value = "all", This will looping on all arrfiles
				if [[ $file == "all" ]]; then
		    		x="all"
	        		file=$d						
					if [[ -f ~/"paramjection/db/""$d""_""$dated""-result.txt" ]]; then
	  					rm ~/"paramjection/db/""$d""_""$dated""-result.txt"
					fi
			
	    		fi
		   
				

				#check if value of -k argument is not empty and is one from the whitelist in arrfiles array	
				if [ ! -z $file ] &&  [[ $file = $d ]]; then

					

									
									
									allfunction() {

										
										if [ "$v" = "true" ]; then
											echo "$yellow** Looking On link [$line] $reset"
										fi

										#this grep special params and put in array 
  										declare -a arr2
  										arr2=(`cat ~/"paramjection/params/$file.txt"`)
										len2=${#arr2[@]}

										#this will looping on the params 
  										for(( b = 0; b < ${len2}; b++))
  											do      

    												pa="${arr2[$b]}"
													if [[ "$line"  == *"$pa="* ]]; then
													    cond="&"
														value=(`echo "$line" | sed "s/$pa=[^&]*/$cond/g" | sed "s/.*$pa=//g" | sed "s/&.*//g"`)														
													
															if [ "$v" = "true" ]; then
																echo "$green FOUND[$pa] $reset"
															fi
																
															
    						    								if [ ! -z "$file" ] &&  [[ $file = $d ]]; then

										  		  				 #ssrf and redirect config || this when the -k equal to ssrf or redirect
 						        		    						if [ $file = ${arrfiles[0]} ] || [ $file = ${arrfiles[2]} ]; then
																		

																			f=$file
       									            						if [ -z "$colab" ]; then 
																				
																				# cond="&"
																				# value=(`echo "$line" | sed "s/$pa=[^&]*/$cond/g" | sed "s/.*$pa=//g" | sed "s/&.*//g"`)
																				if [[ $ans = "y" ]]; then
																	    		  	if [[ $en = "bd" ]] || [[ $en = "d" ]]; then
																	      					.encodeparam $value
																					else 
																							.encodeparam $colab
																					fi
																					
																				else
																					eparam=(`echo "$colab" | sed 's;/;\\\/;g'`)

																				fi																				

       									                		 				.db "$line" "$f" "$colab"													    		 				

       									            						elif [[ ! -z $colab ]]; then

													    		 				if [[ $ans = "y" ]]; then
																	    		  	if [[ $en = "bd" ]] || [[ $en = "d" ]]; then
																	      					.encodeparam $value
																					else 
																							.encodeparam $colab
																					fi
																				else
																					eparam=(`echo "$colab" | sed 's;/;\\\/;g'`)

																				fi
																				.db "$line" "$f" "$colab"
    						    		            						fi

																	#idor and xss config || this will check if -k eqaul to xss or idor
																	elif [[ $file = ${arrfiles[1]} ]] || [[ $file = ${arrfiles[5]} ]]; then															
																			
       									                		    		f=$file
       									            						if [ -z "$can" ]; then 	
																				
																				if [[ $ans = "y" ]]; then
																	    		  	if [[ $en = "bd" ]] || [[ $en = "d" ]]; then
																	      					.encodeparam $value
																					else 
																							.encodeparam $can
																					fi
																					
																				else
																					eparam=(`echo "$can" | sed 's;/;\\\/;g'`)

																				fi	
       									                		 				.db "$line" "$f" "$can"

       									            						elif [[ ! -z $can ]]; then
																			
																				eparam="$can"
													    		 				if [[ $ans = "y" ]]; then																													      			
																					if [[ $en = "bd" ]] || [[ $en = "d" ]]; then
																	      					.encodeparam $value
																					else 
																							.encodeparam $can
																					fi
																				else
																					
																					eparam=(`echo "$can" | sed 's;/;\\\/;g'`)
																				fi
																					
																					
																				.db "$line" "$f" "$can"
    						    		            						fi 

																	#config isql and lfi and rce || this will check if -k equal to isql or lfi or rce
																	elif [[ $file = ${arrfiles[3]} ]] || [[ $file = ${arrfiles[4]} ]] || [[ $file = ${arrfiles[6]} ]]; then
																			
       									                		    		f=$file
       									            						if [ -z "$payload" ]; then 
                    	        		                		       		declare -a arr3
  						        		                		       		arr3=(`cat ~/"paramjection/payloads/"$file"_payloads.txt"`)
						        		                		       		len3=${#arr3[@]}

																	   		#looping in Default payloads
 						        		                		      		 for(( n = 0; n < ${len3}; n++))
  							    		                		            		do 

                    	        		                		                        		inject="${arr3[$n]}"
																									eparam="$inject"
													    		 		                			if [[ $ans = "y" ]]; then
																										if [[ $en = "bd" ]] || [[ $en = "d" ]]; then
																	      									.encodeparam $value
																										else 
																											.encodeparam $inject
																										fi
																										
																									else
																										eparam=(`echo "$inject" | sed 's;/;\\\/;g'`)
																									fi
																									.db "$line" "$f" 
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
																	      						if [[ $en = "bd" ]]; then
																	      							.encodeparam $value
																								else 
																									.encodeparam $inj
																								fi																		

																							else
																								eparam=(`echo "$inj" | sed 's;/;\\\/;g'`)
																							fi
																							.db "$line" "$f" 
                    	        		                		            		done
    						    		            						fi 

																	fi 

													
																fi
													fi
															
											done

											
									}		

								#this loop for list or urls


								files=${list--} # POSIX-compliant; ${1:--} can be used either.
								while IFS= read -r line; do
								  allfunction
								  
								done < <(cat -- "$files")

							#function get stored data from db file and make some handling
							function .catfiles () {
							
								if [[ -f ~/"paramjection/db/""$f""_""$dated""-result.txt" ]]; then
									cat ~/"paramjection/db/""$f""_""$dated""-result.txt" | sort -u
	  								rm ~/"paramjection/db/""$f""_""$dated""-result.txt"
								fi
  			    			} 

							# if -k = "all" and the user choose -o argument
							if [ ! -z $output ] && [[ $x = "all" ]]; then					
								.catfiles  >> ~/"paramjection/temp"					
								cat ~/"paramjection/temp" | sort -u > "$output""_""$dated"

							# if -k all and there are NO output from the user 
			    			elif [ -z $output ] && [[ $x = "all" ]]; then
						  		.catfiles  >> ~/"paramjection/temp"
						  		cat ~/"paramjection/temp" | sort -u > "$x""_""$dated.txt"

							# if -k not "all" and there are some output from the user 
			    			elif [ ! -z $output ] && [[ ! $x = "all" ]]; then
				    	  		.catfiles  > "$output""_""$dated"
						  		echo $bg_green$black"successfully completed here your list >> ""$output""_""$dated"$reset

							# if no one from preveiws condition then do this command
							else
				   				.catfiles > "$f""_""$dated""-res.txt"				  
				   				echo $bg_green$black"successfully completed here your list >> $f_$dated-res.txt"$reset
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
					echo $bg_green$black"successfully completed here your list >> ""$output""_""$dated "$reset

			    elif [ -z $output ] && [[ $x = "all" ]]; then
					echo $bg_green$black"successfully completed here your list >> ""$x""_""$dated.txt"$reset
				fi

	
		



