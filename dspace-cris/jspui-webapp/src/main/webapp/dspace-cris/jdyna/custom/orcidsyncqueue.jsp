<%--

    The contents of this file are subject to the license and copyright
    detailed in the LICENSE and NOTICE files at the root of the source
    tree and available online at

    https://github.com/CILEA/dspace-cris/wiki/License

--%>
<%@ taglib uri="http://www.dspace.org/dspace-tags.tld" prefix="dspace" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="jdynatags" prefix="dyna"%>
<c:set var="root"><%=request.getContextPath()%></c:set>
<c:if test="${!empty anagraficaObject.anagrafica4view['orcid']}">


<script type="text/javascript">

fnServerObjectToArray = function ()
{
	
	return function ( sSource, aoData, fnCallback ) {
		
    	j.ajax( {
            "dataType": 'json',
            "type": "POST",
            "url": "<%= request.getContextPath() %>/json/orcidqueue",
            "data" : {
	            "id" : "${entity.crisID}"
	          },
            "error": function(data){
            	json = new Object();
        		json.aaData = [];
                fnCallback(json);
            	return;
            },
            "success": function (json) {
            	if (json == null || json.error)
            	{
            		json = new Object();
            		json.aaData = [];
	                fnCallback(json);
            		return;
            	}
            	fnCallback(json);
            }
        } );
    };
};

var oTable;

jQuery(document).ready(function() {
	
	drawOrcidDatatable = function() { 
		jQuery('#orcidQueueTable').dataTable( {
		"processing": true,
		"bServerSide": true,
		"sAjaxSource": "<%= request.getContextPath() %>/json/orcidqueue",
		"fnServerData": fnServerObjectToArray(),
		"sAjaxDataProp": "result",
		"bDestroy": true,
	    "aoColumns": [
			{ "mData": "ttext", 
	            "bSortable": true,
	            "sWidth": "3%",
	            "mRender": function(data, type, full) {
	            	if(data=='crisrp')
	                	return '<i class="fa fa-user"></i>';
	            	if(data=='crispj')
	            		return '<i class="fa fa-university"></i>';
	            	if(data=='item')
	                	return '<i class="fa fa-archive"></i>';
	             }	
			},
	        { "mData": "name" , 
	            "bSortable": true,
	            "mRender": function(data, type, full) {
	            	if(full.ttext=='crisrp' || full.ttext=='crispj') {
	            		return '<a href="<%= request.getContextPath() %>/cris/uuid/'+full.uuid+'">' + data + '</a>';
	            	}
	            	else {
	            		 return '<a href="<%= request.getContextPath() %>/handle/'+full.uuid+'">' + data + '</a>';
	            	}
	             }	
			},
	        {
	            "mData": "uuid",
	            "sWidth": "10%",
	            "bSortable": false,
	            "mRender": function(data, type, full) {
	                return '<a class="btn btn-warning" data-operation="3" data-ttext="'+full.ttext+'" data-uuid="'+data+'" data-owner="'+full.owner+'">' + j('#orcidmanualsend').text() + '</a>';
	             }
	        }
	    ]
		} );
	};
	
	oTable = drawOrcidDatatable();
	
	j('#orcidQueueTable tbody').on('click', 'a', function() {
		var operation = j(this).data("operation");
		if(operation == 3) {
			var uuid = j(this).data("uuid");
			var owner = j(this).data("owner");
			var ttext = j(this).data("ttext");
			j.ajax({
				  type: "POST", //or GET
				  url: "<%= request.getContextPath() %>/json/orcidqueue/post/"+ttext,
				  data: {
		            "id" : "${entity.crisID}",
		            "uuid" : uuid,
		            "owner": owner
		          },
				  success: function(response){
					  if(response.status==false) {
						  alert(j("#orciderror").text());  
					  }
					  else {
						  alert(j("#orcidsuccess").text());
					  }
					  oTable = drawOrcidDatatable();
				  }
			} );	
		}
	});


	j('.btn-put-orcid').on('click', function() {
			var ttext = j(this).data("ttext");
			var id = j(this).attr('id');
			j.ajax({
				  type: "POST", //or GET
				  url: "<%= request.getContextPath() %>/json/orcidqueue/put/"+ttext,
				  data: {
		            "id" : "${entity.crisID}",
		            "owner" : "${entity.crisID}"
		          },
				  success: function(response){
					  if(response.status==false) {
						  alert(j("#orciderror").text());  
					  }
					  else {
						  j('#'+id).hide();
						  alert(j("#orcidsuccess").text());
					  }				   		  	
					  oTable = drawOrcidDatatable();
				  }
			} );	
	});
} );




</script>
<div class="panel-group" id="${holder.shortName}">
	<div class="panel panel-default">
    	<div class="panel-heading">
    		<h4 class="panel-title">
        		<a data-toggle="collapse" data-parent="#${holder.shortName}" href="#collapseOne${holder.shortName}">
          			${holder.title} 
        		</a></h4>
    	</div>
		<div id="collapseOne${holder.shortName}" class="panel-collapse collapse in">
			<div class="panel-body">	
			<div class="dynaClear">&nbsp;</div>
            <div class="dynaClear">&nbsp;</div>
            <div class="dynaClear">&nbsp;</div>
			<div class="dynaField"></div>								
					
					<div class="col-md-12">
    						<div class="container">

							<c:choose>	
								<c:when test="${!empty anagraficaObject.anagrafica4view['orcid-push-manual'] && anagraficaObject.anagrafica4view['orcid-push-manual'][0].value.object==1}">
									<span class="label label-warning"><fmt:message key="jsp.orcid.custom.box.label.preferences.manual"/></span>
								</c:when>
								<c:otherwise>
									<span class="label label-info"><fmt:message key="jsp.orcid.custom.box.label.preferences.batch"/></span>											
								</c:otherwise>
							</c:choose>
								<c:if test="${!empty anagraficaObject.anagrafica4view['orcid-push-crisrp-activate-put'] && anagraficaObject.anagrafica4view['orcid-push-crisrp-activate-put'][0].value.object}">
										<button class="btn btn-danger btn-put-orcid" id="buttonPutRP" data-ttext="crisrp"><fmt:message key="jsp.orcid.custom.box.label.preferences.researcher.force.put"/></button>
								</c:if>
								<c:if test="${!empty anagraficaObject.anagrafica4view['orcid-push-crispj-activate-put'] && anagraficaObject.anagrafica4view['orcid-push-crispj-activate-put'][0].value.object}">
										<button class="btn btn-danger btn-put-orcid" id="buttonPutPJ" data-ttext="crispj"><fmt:message key="jsp.orcid.custom.box.label.preferences.project.force.put"/></button>
								</c:if>
								<c:if test="${!empty anagraficaObject.anagrafica4view['orcid-push-item-activate-put'] && anagraficaObject.anagrafica4view['orcid-push-item-activate-put'][0].value.object}">
										<button class="btn btn-danger btn-put-orcid" id="buttonPutItem" data-ttext="item"><fmt:message key="jsp.orcid.custom.box.label.preferences.publication.force.put"/></button>
								</c:if>
							<hr/>
							<div class="clearfix">&nbsp;</div>
							<table id="orcidQueueTable" class="table table-striped table-bordered">
					        <thead>
					            <tr>
					                <th></th>
					                <th>Name</th>
					                <th></th>
					            </tr>
					        </thead>
						    </table>
					</div></div>
			</div>
		</div>
	</div>
</div>
<span id="orcidmanualsend" style="display: none;"><fmt:message key="jsp.orcid.custom.box.label.preferences.button.manual"/></span>
<span id="orcidsuccess" style="display: none;"><fmt:message key="jsp.orcid.custom.box.label.send.success"/></span>
<span id="orciderror" style="display: none;"><fmt:message key="jsp.orcid.custom.box.label.send.error"/></span>
</c:if>