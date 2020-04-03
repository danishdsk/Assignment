
/**
* C9Numeric.js
* @author: Cloud 9
* @contributor: Developer 13
* @version: 1.0 - 13 June, 2019 04:00 PM
*
* Created by ------. Please report any bugs to ---
*/

(function ($) {
	$.fn.C9Numeric = function (method) {
		this.each(function (index) {
			var v_class = $(this).attr('class') == undefined ? "" : $(this).attr('class');
			var v_id 	= $(this).attr('id') 	== undefined ? "" : $(this).attr('id');
			var v_dec 	= $(this).attr('c9n-dec') 	== undefined ? "2" : $(this).attr('c9n-dec');
			var v_group = $(this).attr('c9n-group') == undefined ? "" : $(this).attr('c9n-group');
			var v_sign 	= $(this).attr('c9n-sign') 	== undefined ? "" : $(this).attr('c9n-sign');
			
			var value	= 0;
			
			if($(this).attr('c9n-display') == 'true')
			{
				value = $(this).text() //$.isNumeric($(this).text()) == true ? $(this).text() : 0;
				$(this).before( '<span id="c9num_' + index + '_' + v_id +'" class="clsc9num '+ v_class +'" c9n-dec="'+ v_dec +'" c9n-group="'+ v_group +'" c9n-sign="'+ v_sign +'" c9n-display="true" c9n-ref="' + index +'" > '+ value +' </span> ' );
				$(this).addClass('clsc9ref_' + index);
				$(this).css('display', 'none');
			}
			else
			{
				value = $(this).val() //$.isNumeric($(this).val()) == true ? $(this).val() : 0;
				$(this).before( '<input type="text" id="c9num_' + index + '_' + v_id +'" class="clsc9num '+ v_class +'" value="'+ value +'" c9n-dec="'+ v_dec +'" c9n-sign="'+ v_sign +'" c9n-group="'+ v_group +'" c9n-display="false" c9n-ref="' + index +'" />' );
				$(this).addClass('clsc9ref_' + index);
				$(this).css('display', 'none');
				
				$.C9UpdateNumber('#c9num_' + index + '_' + v_id);
			}
			
			$.C9Number('#c9num_' + index + '_' + v_id);
		});
    };

	//Function for decorate number
    $.C9Number = function C9_Number(e) {
		if ($(e).attr('c9n-group') == "" || $(e).attr('c9n-group') == "0" || $(e).attr('c9n-group') == 0) {
			$(e).attr('c9n-group', '2');
		}
		
        if($(e).attr('c9n-display') == 'true'){
			$.C9NumberDisplay(e, parseInt($(e).attr('c9n-group')));
		}
		else{
			$.C9NumberInput(e, parseInt($(e).attr('c9n-group')));
		}
    }
	
	// Function for number format of input fields
	$.C9NumberInput = function C9_NumberInput(e, g){
		var arr = $(e).val().trim().split('.');
		var num = Number(arr[0]).toString();
		var neg = '';
		
		if(parseInt(num) != Math.abs(parseInt(num))){
			neg = '-';
			num = (-1 * parseInt(num)).toString();
		}
		var len = num.length;
		
		if(len > 3){
			$(e).val('');
			var r = (len - 3) % g;
			var s = '';
			var c = 1;
			for( var i in num ){
				if(i == r){
					c = 1;
				}
				
				if(i < (len - 3)){
					if(i < r){
						if(c == r){
							s = ',';
							c = 1;
						}
						else{
							c++;
						}
					}
					else{
						if(c == g){
							s = ',';
							c = 1;
						}
						else{
							c++;
						}
					}
				}
				$(e).val(neg + $(e).val()+ num[i] + s) ;
				s = '';
				neg = '';
			}
			if(arr.length > 1){
				$(e).val($(e).val() + '.' + arr[1]);
			}
		}
		
		$(e).val($(e).attr('c9n-sign') + $(e).val());
	}
	
	// Function for number format of Display fields
	$.C9NumberDisplay = function C9_NumberDisplay(e, g){
		var arr = $(e).text().trim().split('.');
		var num = Number(arr[0]).toString();
		var neg = '';
		
		if(parseInt(num) != Math.abs(parseInt(num))){
			neg = '-';
			num = (-1 * parseInt(num)).toString();
		}
		var len = num.length;
			
		if(len > 3){
			$(e).text('');
			var r = (len - 3) % g;
			var s = '';
			var c = 1;
			for( var i in num ){
				if(i == r){
					c = 1;
				}
				
				if(i < (len - 3)){
					if(i < r){
						if(c == r){
							s = ',';
							c = 1;
						}
						else{
							c++;
						}
					}
					else{
						if(c == g){
							s = ',';
							c = 1;
						}
						else{
							c++;
						}
					}
				}
				$(e).text(neg + $(e).text()+ num[i] + s) ;
				s = '';
				neg = '';
			}
			if(arr.length > 1){
				$(e).text($(e).text() + '.' + arr[1]);
			}
		}
		
		$(e).text($(e).attr('c9n-sign') + $(e).text());
	}
	
	// Function for Get actual number.
	 $.C9GetNumber = function C9_GetNumber(e){
		 if($(e).attr('c9n-display') == 'true'){
			return $(e).text().replace(/,/g, '').substring($(e).attr('c9n-sign').length);
		}
		else{
			return $(e).val().replace(/,/g, '').substring($(e).attr('c9n-sign').length);
		}
	 }
	 
	 // Function for update and validate number.
	 $.C9UpdateNumber = function C9_UpdateNumber(e){
		 
		 $(e).focusin(function(){
			 $(e).val($.C9GetNumber(e));
		 });
		 
		 $(e).on('blur', function(event){
			$.C9Number(e);
			$(e).next('.clsc9ref_' + $(e).attr('c9n-ref')).val($.C9GetNumber(e));
		 });
		 
		 $(e).on("paste input propertychange keypress", function(event){
			 if(event.type == "paste"){
				 return false;
			 }
			 else if(event.type == "keypress"){
				 var start = event.target.selectionStart;
				 var end = event.target.selectionEnd;
				 var charCode = (event.which) ? event.which : event.keyCode;
				 var prec = this.value.split('.')[0].length;
				 
				 // For convert in positive number.
				 if(charCode == 43){
					 if (this.value.split('-').length > 1) {
						 $(e).val(-1 * parseFloat($(e).val()));
                    }
				 }
				 
				 // For convert in Negative number.
				 if(charCode == 45){
					 if (this.value.split('-').length == 1) {
						 $(e).val(-1 * parseFloat($(e).val()));
                    }
				 }
				 
				 // For skip special characters
				 if (charCode != 46 && charCode > 31 && (charCode < 48 || charCode > 57)) {
                       
					 return false;
				 }
				 
				 // For skip decimal point when c9n-dec is zero.
				 if(charCode == 46 && parseInt($(this).attr('c9n-dec')) == 0){
					 return false;
				 }
				 
				 // For just one dot
				 if (this.value.split('.').length > 1 && charCode == 46) {
					 if(!(start <= prec && end > prec)){
						 return false;
					 }
				 }
				 
				 // For skip number when decimal limit reached.
				 if($(this).val().indexOf('.') != -1 &&  start > prec && charCode != 8 && charCode != 9){
					 if ($(this).val().substring($(this).val().indexOf('.')).length > parseInt($(this).attr('c9n-dec')) && start == end) {
                         return false;
                     }
				 }
				 
			 }
			 
		 });
	 }
}(jQuery, window, document));