<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common/taglibs.jsp"%>
<!DOCTYPE HTML>
<html lang="zh-cn">
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1">
</head>
<body>
	<div class="col-sm-2">
		<ul id="treeDemo" class="ztree" url="${ctx}/menu/renderTree"></ul>
	</div>
	<div class="col-sm-10">
		<div id="toolbar">
			<shiro:hasPermission name="menu:save">
				<button type="button" class="btn btn-primary" data-toggle="modal" onclick='creat(model);'>新增菜单</button>
			</shiro:hasPermission>
			<shiro:hasPermission name="menu:edit">
				<button type="button" class="btn btn-primary" data-toggle="modal" onclick="edit(model);">编辑菜单</button>
			</shiro:hasPermission>
			<shiro:hasPermission name="menu:remove">
				<button type="button" class="btn btn-primary" onclick="remove(model);">删除菜单</button>
			</shiro:hasPermission>
			<input id="search_menuId" type="hidden">
		</div>
		<div class="container" style="width: 100%">
			<table id="demo-table">
			</table>
		</div>
	</div>
	<div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLable" aria-hidden="true">
		<div class="modal-dialog  modal-lg">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal" aria-hidden="true">x</button>
					<h4 class="modal-title" id="myModalLabel">菜单</h4>
				</div>
				<div class="modal-body">
					<div class="col-lg-12">
						<form method="get" id="saveForm" class="form-horizontal">
							<div class="form-group">
								<label class="col-sm-1 control-label"><span class="red">*</span>名称:</label>
								<div class="col-sm-3">
									<input type="text" class="form-control" name="name" required="true">
								</div>
								<label class="col-sm-1 control-label"><span class="red">*</span>菜单url:</label>
								<div class="col-sm-3">
									<input type="text" class="form-control" name="url" required="true">
								</div>
								<label class="col-sm-1 control-label"><span class="red">*</span>类型:</label> <select id="type" name="type" class="col-sm-1 form-control select2" required="true">
								</select>
							</div>
							<div class="form-group">
								<label class="col-sm-1 control-label"><span class="red">*</span>授权标识:</label>
								<div class="col-sm-3">
									<input type="text" class="form-control" name="perms" required="true">
								</div>
								<label class="col-sm-1 control-label">排序:</label>
								<div class="col-sm-3">
									<input type="text" class="form-control" name="orderNum">
								</div>
								<label class="col-sm-1 control-label">是否使用:</label> <select id="isUse" name="isUse" class="col-sm-1 form-control select2">
								</select>
							</div>
							<input type="hidden" name="menuId" /> <input type="hidden" name="parentId" />
						</form>
					</div>
				</div>
				<div class="modal-footer" style="border: none; margin-left: 40%; padding-bottom: 20px;">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" onclick="save(model);">提交</button>
				</div>
			</div>
		</div>
	</div>
	<script type="text/javascript">
        var model = {
            id : "myModal",
            formId : "saveForm",
            entityId : "menuId",
            createTitle : "新增菜单",
            editTitle : "编辑菜单",
            editURL : "${ctx}/menu",
            saveURL : "${ctx}/menu/add",
            removeURL : "${ctx}/menu/remove",
            isTree : true,
            dataURL : '${ctx}/dataDict/getData?groupCode='
        //是否有树
        }

        var isUseStore = getDataStore(model.dataURL + 'yesOrNo');
        var menuTypeStore = getDataStore(model.dataURL + 'menuType');

        var setting = {
            data : {
                simpleData : {
                    enable : true,
                    idKey : "menuId",
                    pIdKey : "parentId",
                    rootPId : 0
                },
                key : {
                    url : "xUrl"
                }
            },
            callback : {
                onClick : zTreeOnClick
            }
        };

        var ztree;

        function zTreeOnClick(event, treeId, treeNode, clickFlag) {
            $('#search_menuId').val(treeNode.menuId);

            //刷新表格
            $('#demo-table').bootstrapTable('refresh');
        }

        function myCreate(model) {
            $('#' + model.formId + " input[name='parentId']").val($('#search_menuId').val());
        }

        function myEdit(obj, model) {
        }

        $(function() {
            //加载列表
            initTable();

            //加载树
            var jsonTree = getDataStore($("#treeDemo").attr("url"));
            ztree = $.fn.zTree.init($("#treeDemo"), setting, jsonTree);

            //加载下拉
            $("#isUse").select2({
                placeholder : "--请选择--",
                dropdownParent : $("#myModal"),
                allowClear : true,
                width : 150,
                minimumResultsForSearch : -1,
                data : isUseStore
            });

            $("#type").select2({
                placeholder : "--请选择--",
                dropdownParent : $("#myModal"),
                allowClear : true,
                width : 150,
                minimumResultsForSearch : -1,
                data : menuTypeStore
            });
        });

        function doQuery(params) {
            $('#demo-table').bootstrapTable('refresh'); //刷新表格
        }
        function initTable() {
            var url = "${ctx}/menu/list";
            $('#demo-table').bootstrapTable({
                method : 'post',
                contentType : 'application/x-www-form-urlencoded',
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
                pagination : true,// 分页 
                paginationLoop : false,//设置为 true 启用分页条无限循环的功能
                pageList : [ 5, 10, 20 ],
                classes : 'table table-hover table-no-bordered',
                smartDisplay : false,
                idField : 'menuId',//指定主键列
                sortName : 'menuId',
                sortOrder : 'desc',
                escape : true,
                maintainSelected : true,//设置为 true 在点击分页按钮或搜索按钮时，将记住checkbox的选择项
                toolbar : '#toolbar',//一个jQuery 选择器，指明自定义的toolbar 例如:
                queryParams : queryParams,
                columns : [ {
                    field : 'state',
                    checkbox : true
                }, {
                    field : 'name',
                    title : '菜单名称',
                    sortable : true,
                    halign : 'center'
                }, {
                    field : 'url',
                    title : '菜单url',
                    sortable : true,
                    halign : 'center'
                }, {
                    field : 'perms',
                    title : '授权标识',
                    sortable : true,
                    halign : 'center'
                }, {
                    field : 'isUse',
                    title : '是否使用',
                    sortable : true,
                    halign : 'center'
                }, {
                    field : 'orderNum',
                    title : '排序',
                    sortable : true,
                    halign : 'center'
                } ]
            }).on('all.bs.table', function(e, name, args) {
                $('[data-toggle="tooltip"]').tooltip();
                $('[data-toggle="popover"]').popover();
            });

        }

        /** 替换数据为文字 */
        function genderFormatter(value) {
            if (value == null || value == undefined) {
                return "-";
            } else if (value == 1) {
                return "是";
            } else if (value == 0) {
                return "否";
            }
        }

        function queryParams(params) {
            var param = {
                parentId : $('#search_menuId').val(),
                limit : this.limit, // 页面大小
                offset : this.offset, // 页码
                pageindex : this.pageNumber,
                pageSize : this.pageSize
            }
            return param;
        }

        /** 刷新页面 */
        function refresh() {
            $('#demo-table').bootstrapTable('refresh');
        }
    </script>
</body>
</html>
