jQuery.fn.onlyAlphabet = function(){
	return this.each(function(){

			$(this).keydown(function(e){
				var key = e.charCode || e.keyCode || 0;
				return (
						key == 8 ||
						key == 13 ||
						key == 46 ||
						key == 110 ||
						key == 190 ||
						key == 116 ||
						(key >= 35 && key <= 40) ||  //방향키
						(key >= 65 && key <= 90) ||  //Alphabet
						(key >= 48 && key <= 57) ||  //숫자키
						(key >= 96 && key <= 105) 	 //넘버키
						
				);
				
			});
	});
};

jQuery.fn.emailAddress = function(){
	return this.each(function(){

			$(this).keydown(function(e){
				var key = e.charCode || e.keyCode || 0;
console.log(key);				
				return (
						key == 8 ||
						key == 13 ||
						key == 46 ||
						key == 110 ||
						key == 190 ||
						key == 116 ||
						(key >= 35 && key <= 40) ||  //방향키
						(key >= 65 && key <= 90) ||  //Alphabet
						(key >= 48 && key <= 57) ||  //숫자키
						(key >= 96 && key <= 105) 	 //넘버키
						
				);
				
			});
			
			$(this).keyup(function(e){
				var str = $(this).val();
				var p = /[`~!#$%^&*_|+=?;:\)\(\'\"<>\{\}\[\]]/gi;
			    $(this).val(str.replace(p,''));
				
			});
	});
};