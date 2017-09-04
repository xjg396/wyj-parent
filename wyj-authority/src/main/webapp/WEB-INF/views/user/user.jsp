<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common/taglibs.jsp"%>
<!DOCTYPE HTML>
<html lang="zh-cn">
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>huiju</title>
<link href="${bathPath}/plugins/bootstrap-3.3.7/css/bootstrap.min.css" rel="stylesheet" />
<link href="${bathPath}/plugins/bootstrap-table-1.11.1/bootstrap-table.min.css" rel="stylesheet" />
<link href="${bathPath}/plugins/jquery-confirm/jquery-confirm.min.css" rel="stylesheet" />
<link href="${bathPath}/css/public.css" rel="stylesheet" />
<link href="${bathPath}/plugins/select2-4.0.3/dist/css/select2.min.css" rel="stylesheet" />

<style>
.select2-container--open {
	z-index: 9999999
}
</style>
</head>
<body>
	<div id="main">
		<div id="toolbar">
			<button type="button" class="btn btn-primary" data-toggle="modal" onclick='creat(model);'>新增用户</button>
			<button type="button" class="btn btn-primary" data-toggle="modal" onclick="edit(model);">编辑用户</button>
			<button type="button" class="btn btn-primary" onclick="remove(model);">删除用户</button>
		</div>
		<table id="table"></table>
	</div>
	<div class="container" style="width: 100%">
		<table id="demo-table">
		</table>
	</div>


	<div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLable" aria-hidden="true">
		<div class="modal-dialog  modal-lg">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal" aria-hidden="true">x</button>
					<h4 class="modal-title" id="myModalLabel">标题</h4>
				</div>
				<div class="modal-body">
					<form method="get" id="saveForm">
						<div class="form-group">
							<label class="col-sm-1 control-label"><span class="red">*</span>昵称:</label>
							<div class="col-sm-3">
								<input type="text" class="form-control" name="userName">
							</div>
							<label class="col-sm-1 control-label"><span class="red">*</span>密码:</label>
							<div class="col-sm-3">
								<input type="text" class="form-control" name="password">
							</div>
							<label class="col-sm-1 control-label"><span class="red">*</span>姓名:</label>
							<div class="col-sm-3">
								<input type="text" class="form-control" name="name">
							</div>
						</div>
						<div class="form-group">
							<label class="col-sm-1 control-label">年龄:</label>
							<div class="col-sm-3">
								<input type="text" class="form-control" name="age">
							</div>
							<label class="col-sm-1 control-label">手机号码:</label>
							<div class="col-sm-3">
								<input type="text" class="form-control" name="phone">
							</div>
							<label class="col-sm-1 control-label">性别:</label> <select id="sel_menu2" class="col-sm-1 form-control select2">
							</select>
						</div>
						<div class="form-group">
							<label class="col-sm-1 control-label">邮箱:</label>
							<div class="col-sm-3">
								<input type="text" class="form-control" name="email">
							</div>
							<label class="col-sm-1 control-label">地址:</label>
							<div class="col-sm-3">
								<input type="text" class="form-control" name="address">
							</div>
						</div>
						<div class="form-group"></div>
						<input type="hidden" name="userId">
					</form>
				</div>


				<div class="modal-footer" style="border: none; margin-left: 40%; padding-bottom: 20px;">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" onclick="submit(model);">提交</button>
				</div>
			</div>
		</div>
	</div>


	<script src="${bathPath}/plugins/jquery-3.2.1/jquery-3.2.1.min.js"></script>
	<script src="${bathPath}/plugins/bootstrap-3.3.7/js/bootstrap.min.js"></script>
	<script src="${bathPath}/plugins/bootstrap-table-1.11.1/bootstrap-table.min.js"></script>
	<script src="${bathPath}/plugins/bootstrap-table-1.11.1/locale/bootstrap-table-zh-CN.js"></script>
	<script src="${bathPath}/plugins/jquery-confirm/jquery-confirm.min.js"></script>
	<script src="${bathPath}/plugins/select2-4.0.3/dist/js/select2.min.js"></script>
	<script src="${bathPath}/plugins/select2-4.0.3/dist/js/i18n/zh-CN.js"></script>
	<script src="${bathPath}/js/base.js"></script>


	<script type="text/javascript">
        var model = {
            id : "myModal",
            formId : "saveForm",
            entityId : "userId",
            createTitle : "新增字典",
            editTitle : "编辑字典",
            editURL : "${ctx}/user",
            saveURL : "${ctx}/user/add",
            removeURL : "${ctx}/user/remove"
        }

        $(function() {
            initTable();
            $("#sel_menu2").select2({
                placeholder : "--请选择--",
                dropdownParent : $("#myModal"),
                allowClear : true,
                width : 180,
                data : [ {
                    id : 1,
                    text : '男'
                }, {
                    id : 2,
                    text : '女'
                } ]
            });
        });

        function doQuery(params) {
            $('#demo-table').bootstrapTable('refresh'); //刷新表格
        }
        function initTable() {
            var url = "${ctx}/user/list";
            $('#demo-table').bootstrapTable({
                //                 url : '${bathPath}/data/data1.json',
                method : 'post',
                url : url,
                editable : true,//开启编辑模式
                height : $(window).height() - 110,//定义表格的高度。
                striped : true,//设置为 true 会有隔行变色效果
                search : true,//是否启用搜索框
                searchOnEnterKey : true,//设置为 true时，按回车触发搜索方法，否则自动触发搜索方法
                showRefresh : true,//是否显示 刷新按钮
                showToggle : true,//是否显示 切换试图（table/card）按钮
                showColumns : true,//是否显示 内容列下拉框
                minimumCountColumns : 2,
                showPaginationSwitch : true,//是否显示 数据条数选择框
                clickToSelect : true,//设置true 将在点击行时，自动选择rediobox 和 checkbox
                detailView : true,//设置为 true 可以显示详细页面模式。
                detailFormatter : 'detailFormatter',//格式化详细页面模式的视图。
                pagination : true,// 分页 
                paginationLoop : false,//设置为 true 启用分页条无限循环的功能
                pageList : [ 5, 10, 20 ],
                classes : 'table table-hover table-no-bordered',
                //sidePagination: 'server',
                //silentSort: false,
                smartDisplay : false,
                idField : 'userId',//指定主键列
                sortName : 'userId',
                sortOrder : 'desc',
                escape : true,
                maintainSelected : true,//设置为 true 在点击分页按钮或搜索按钮时，将记住checkbox的选择项
                toolbar : '#toolbar',//一个jQuery 选择器，指明自定义的toolbar 例如:
                queryParams : queryParams,
                columns : [ {
                    field : 'state',
                    checkbox : true
                }, {
                    field : 'userName',
                    title : '账号',
                    sortable : true,
                    halign : 'center'
                }, {
                    field : 'password',
                    title : '密码',
                    sortable : true,
                    halign : 'center'
                }, {
                    field : 'name',
                    title : '姓名',
                    sortable : true,
                    halign : 'center'
                }, {
                    field : 'sex',
                    title : '性别',
                    sortable : true,
                    halign : 'center'
                }, {
                    field : 'age',
                    title : '年龄',
                    sortable : true,
                    halign : 'center'
                }, {
                    field : 'phone',
                    title : '手机',
                    sortable : true,
                    halign : 'center'
                }, {
                    field : 'email',
                    title : '邮箱',
                    sortable : true,
                    halign : 'center'
                }, {
                    field : 'address',
                    title : '地址',
                    sortable : true,
                    halign : 'center'
                } ]
            }).on('all.bs.table', function(e, name, args) {
                $('[data-toggle="tooltip"]').tooltip();
                $('[data-toggle="popover"]').popover();
            });

        }
        function detailFormatter(index, row) {
            var html = [];
            $.each(row, function(key, value) {
                html.push('<p><b>' + key + ':</b> ' + value + '</p>');
            });
            return html.join('');
        }

        function queryParams(params) {
            var param = {
                //                 orgCode : $("#orgCode").val(),
                //                 userName : $("#userName").val(),
                //                 startDate : $("#startDate").val(),
                //                 endDate : $("#endDate").val(),
                limit : this.limit, // 页面大小
                offset : this.offset, // 页码
                pageindex : this.pageNumber,
                pageSize : this.pageSize
            }
            return param;
        }

        // 用于server 分页，表格数据量太大的话 不想一次查询所有数据，可以使用server分页查询，数据量小的话可以直接把sidePagination: "server"  改为 sidePagination: "client" ，同时去掉responseHandler: responseHandler就可以了，
        function responseHandler(res) {
            if (res) {
                return {
                    "rows" : res.result,
                    "total" : res.totalCount
                };
            } else {
                return {
                    "rows" : [],
                    "total" : 0
                };
            }
        }

        /** 刷新页面 */
        function refresh() {
            $('#demo-table').bootstrapTable('refresh');
        }

        //         function submit() {
        //             $.confirm({
        //                 title : '提示！',
        //                 content : '确定保存吗?',
        //                 buttons : {
        //                     ok : {
        //                         text : "确定",
        //                         btnClass : 'btn-primary',
        //                         keys : [ 'enter' ],
        //                         action : function() {
        //                             $.ajax({
        //                                 type : 'post',
        //                                 url : '${ctx}/user/add',
        //                                 data : $('#saveForm').serialize(),
        //                                 dataType : 'json',
        //                                 success : function() {
        //                                     $('#myModal').modal('hide');
        //                                 }
        //                             });

        //                         }
        //                     },
        //                     cancel : {
        //                         text : "取消",
        //                         btnClass : 'btn-primary',
        //                         keys : [ 'esc' ],
        //                         action : function() {
        //                         }

        //                     }
        //                 }
        //             });
        //         }

        //         function creat() {
        //             $(':input', '#saveForm').not(':button,:submit,:reset') //将myform表单中input元素type为button、submit、reset、hidden排除
        //             .val('') //将input元素的value设为空值
        //             .removeAttr('checked');
        //             $('#myModal').modal('show');
        //         }

        //         function edit() {
        //             var selectRow = $("#demo-table").bootstrapTable('getSelections');
        //             if (selectRow.length != 1) {
        //                 alert('请选择并只能选择一条数据进行编辑！');
        //                 return false;
        //             }
        //             var id = selectRow[0].userId;
        //             $(':input', '#saveForm').not(':button,:submit,:reset') //将myform表单中input元素type为button、submit、reset、hidden排除
        //             .val('') //将input元素的value设为空值
        //             .removeAttr('checked')

        //             $('#myModal').modal('show');
        //             $.ajax({
        //                 type : 'get',
        //                 url : '${ctx}/user' + '/' + id + '?time=' + new Date().getTime(),
        //                 dataType : 'json',
        //                 success : function(data) {
        //                     var obj = data.data.obj;
        //                     for ( var o in obj) {
        //                         var e = '#myModal' + ' input[name=' + o + ']';
        //                         $(e).val(obj[o]);
        //                     }
        //                 }

        //             })
        //         }

        //         function remove() {
        //             var selectRow = $("#demo-table").bootstrapTable('getSelections');
        //             if (selectRow.length != 1) {
        //                 alert('请选择并只能选择一条数据进行编辑！');
        //                 return false;
        //             }
        //             var id = selectRow[0].userId;

        //             $.confirm({
        //                 title : '提示！',
        //                 content : '确定删除吗?',
        //                 buttons : {
        //                     ok : {
        //                         text : "确定",
        //                         btnClass : 'btn-primary',
        //                         keys : [ 'enter' ],
        //                         action : function() {
        //                             $.ajax({
        //                                 type : 'post',
        //                                 url : '${ctx}/user/remove',
        //                                 data : {
        //                                     id : id
        //                                 },
        //                                 dataType : 'json',
        //                                 success : function(result) {
        //                                     if (result.success) {
        //                                         refresh();
        //                                     }
        //                                 }
        //                             });

        //                         }
        //                     },
        //                     cancel : {
        //                         text : "取消",
        //                         btnClass : 'btn-primary',
        //                         keys : [ 'esc' ],
        //                         action : function() {
        //                         }

        //                     }
        //                 }
        //             });
        //         }
    </script>
</body>
</html>