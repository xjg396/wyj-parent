function save(model) {
    $.confirm({
        title : '提示！',
        content : '确定保存吗?',
        buttons : {
            ok : {
                text : "确定",
                btnClass : 'btn-primary',
                keys : [ 'enter' ],
                action : function() {
                    var data = $('#' + model.formId).serialize();
//                    $.each($("select[multiple]"), function(i, select) {// 查找多选的下拉
//                        var j = 0;
//                        var reslist = $("#" + select.id).select2("data");// 得到下拉的值
//                        $.each(reslist, function(j, res) {
//                            data = data + '&' + select.id + 's[' + j + ']' + '.' + select.id + 'Id=' + res.id;
//                        });
//                    });

                    $.ajax({
                        type : 'post',
                        url : model.saveURL,
                        data : data,
                        dataType : 'json',
                        success : function(result) {
                            if (result.success) {
                                refresh(); // 刷新表格
                                if (model.isTree == true) {
                                    reloadTree();// 刷新树
                                }
                                $('#' + model.id).modal('hide');
                            }

                        },
                        error : function(XMLHttpRequest, textStatus, errorThrown) {
                            alert("请求异常");
                        }
                    });

                }
            },
            cancel : {
                text : "取消",
                btnClass : 'btn-primary',
                keys : [ 'esc' ],
                action : function() {
                }

            }
        }
    });
}

function creat(model) {
    $(':input', '#' + model.formId).not(':button,:submit,:reset') // 将myform表单中input元素type为button、submit、reset、hidden排除
    .val('') // 将input元素的value设为空值
    .removeAttr('checked');
    $('select').val(null).trigger('change');// 控件的值设置为null：清除Select2控件中的所有当前选择
    $('#' + model.id).modal('show');
    myCreate(model);
}

function edit(model) {
    var selectRow = $("#demo-table").bootstrapTable('getSelections');
    if (selectRow.length != 1) {
        alert('请选择并只能选择一条数据进行编辑！');
        return false;
    }
    var selectRowData = selectRow[0];
    var id = selectRowData[model.entityId];
    $(':input', '#' + model.formId).not(':button,:submit,:reset') // 将myform表单中input元素type为button、submit、reset、hidden排除
    .val('') // 将input元素的value设为空值
    .removeAttr('checked')

    $('#' + model.id).modal('show');
    $.ajax({
        type : 'get',
        url : model.editURL + '/' + id + '?time=' + new Date().getTime(),
        dataType : 'json',
        success : function(data) {
            var obj = data.data.obj;
            for ( var o in obj) {
                if($('#'+o).is('select')){
                    $("#"+o).val(obj[o]).trigger("change");
                    continue;
                }
                var e = '#' + model.id + ' input[name=' + o + ']';
                $(e).val(obj[o]);
            }
            myEdit(obj, model);
        }

    })
}

function remove(model) {
    var selectRows = $("#demo-table").bootstrapTable('getSelections');
    if (selectRows.length == 0) {
        alert('请选择要删除的数据!');
        return false;
    }
    // 将记录ID保存到数值
    var ids = new Array();
    for ( var i in selectRows) {
        ids.push(selectRows[i][model.entityId]);
    }

    $.confirm({
        title : '提示！',
        content : '确定删除吗?',
        buttons : {
            ok : {
                text : "确定",
                btnClass : 'btn-primary',
                keys : [ 'enter' ],
                action : function() {
                    $.ajax({
                        type : 'post',
                        url : model.removeURL,
                        data : {
                            ids : ids
                        },
                        traditional: true,
                        dataType : 'json',
                        success : function(result) {
                            if (result.success) {
                                refresh();
                                if (model.isTree == true) {
                                    reloadTree();// 刷新树
                                }
                            }
                        }
                    });

                }
            },
            cancel : {
                text : "取消",
                btnClass : 'btn-primary',
                keys : [ 'esc' ],
                action : function() {
                }

            }
        }
    });
}

/** 重新加载树 */
function reloadTree() {
    var tree = $("#treeDemo");
    var treeUrl = tree.attr("url");

    if (treeUrl != null) {
        $.fn.zTree.destroy("treeDemo");
        $.fn.zTree.init(tree, setting(treeUrl));
    }
}


function getDataStore(url){
    var dataStore;
    $.ajax({
        dataType : 'json',
        type : 'get',
        url : url,
        async : false,
        success: function(data){
            dataStore=data;
        }
     });
    return dataStore;
}
