package com.wyj.controller.data;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.alibaba.fastjson.JSON;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.wyj.entity.data.DataDict;
import com.wyj.entity.data.DataGroup;
import com.wyj.service.data.DataDictService;
import com.wyj.service.data.DataGroupService;
import com.wyj.utils.Retval;

/**
 * 
 * 
 * 
 * @author：WangYuanJun
 * @date：2017年8月23日 下午11:45:50
 */
@Controller
@RequestMapping(value = "/dataDict")
public class DataDictController {
    private Logger logger = LoggerFactory.getLogger(this.getClass());

    @Autowired
    private DataDictService dataDictService;

    @Autowired
    private DataGroupService dataGroupService;

    @RequestMapping(value = "/index", method = RequestMethod.GET)
    private String index() {
        return "/data/dataDict";
    }

    @ResponseBody
    @RequestMapping(value = "/list", method = RequestMethod.POST)
    public String query(@RequestParam(value = "offset", required = true, defaultValue = "1") Integer page, @RequestParam(value = "limit", required = false, defaultValue = "10") Integer pageSize,Long dataGroupId) {
        PageHelper.startPage(page, pageSize);
        DataDict dataDict = new DataDict();
        DataGroup dataGroup = new DataGroup();
        dataGroup.setGroupId(dataGroupId);
        dataDict.setDataGroup(dataGroup);
        List<DataDict> dataGroups = dataDictService.list(dataDict);
        PageInfo<DataDict> pageInfo = new PageInfo<DataDict>(dataGroups);
        return JSON.toJSONString(pageInfo.getList());
    }

    @ResponseBody
    @RequestMapping(value = "/add", method = RequestMethod.POST)
    public Retval save(DataDict dataDict) {
        Retval retval = Retval.newInstance();
        try {
            if(dataDict.getDictId() == null){
                dataDictService.save(dataDict);
            }else{
                dataDictService.update(dataDict);
            }
        } catch (Exception e) {
            logger.error(e.getMessage(), e);
        }
        return retval;
    }

    @ResponseBody
    @RequestMapping(value = "/{id}", method = RequestMethod.GET)
    public Retval edit(@PathVariable String id) {
        Retval retval = Retval.newInstance();
        DataDict dataDict = dataDictService.getObjectById(Long.valueOf(id));
        retval.put("obj", dataDict);
        return retval;
    }

    @ResponseBody
    @RequestMapping(value = "/remove", method = RequestMethod.POST)
    public Retval remove(@RequestParam Long id) {
        Retval retval = Retval.newInstance();
        try {
            dataDictService.remove(id);

        } catch (Exception e) {
            logger.error(e.getMessage(), e);
            retval.fail(e.getMessage());
        }
        return retval;
    }

    /**
     * 加载数
     * 
     * @param id
     * @param type
     * @return
     */
    @ResponseBody
    @RequestMapping(value = "/renderTree", method = RequestMethod.GET)
    public List<Map<String, Object>> renderTree(Long id, String type) {
        List<Map<String, Object>> returnList = new ArrayList<Map<String, Object>>();
        // 加载根节点
        if (StringUtils.isEmpty(id)) {
            Map<String, Object> root = new HashMap<String, Object>();

            root.put("id", 0);// 根节点的ID
            root.put("name", "数字字典分组"); // 根节点的名字
            root.put("isParent", true);//// 设置根节点为父节点

            // 加载一级节点
            List<Map<String, Object>> returnList1 = new ArrayList<Map<String, Object>>();
            List<DataGroup> dataGroups = dataGroupService.list();
            for (DataGroup dataGroup : dataGroups) {
                Map<String, Object> node = new HashMap<String, Object>();
                node.put("id", dataGroup.getGroupId());
                node.put("name", dataGroup.getGroupName());
                node.put("isParent", false);
                returnList1.add(node);
            }

            root.put("children", returnList1);
            returnList.add(root);

        }
        return returnList;
    }


    /**
     * 显示数据字典下拉
     * @param groupCode
     * @return
     */
    @ResponseBody
    @RequestMapping(value = "/getData", method = RequestMethod.GET)
    public String getDataDictByGroupCode(@RequestParam String groupCode) {

        List<Map<Long, String>> map = dataDictService.getDataDictByGroupCode(groupCode);
        return JSON.toJSONString(map);
    }

}