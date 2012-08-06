/*******************************************************************************
 * Copyright (c) 2011, 2012 EnergyOS.Org
 *
 * Licensed by EnergyOS.Org under one or more contributor license agreements.
 * See the NOTICE file distributed with this work for additional information
 * regarding copyright ownership.  The EnergyOS.org licenses this file
 * to you under the Apache License, Version 2.0 (the "License"); you may not
 * use this file except in compliance with the License.  You may obtain a copy
 * of the License at:
 *  
 *   http://www.apache.org/licenses/LICENSE-2.0
 *  
 *  Unless required by applicable law or agreed to in writing,
 *  software distributed under the License is distributed on an
 *  "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 *  KIND, either express or implied.  See the License for the
 *  specific language governing permissions and limitations
 *  under the License.
 *  
 ******************************************************************************
*/

// WARNING: DO NOT EDIT THIS FILE. THIS FILE IS MANAGED BY SPRING ROO.
// You may push code into the target .java compilation unit if you wish to edit any member(s).

package org.energyos.espi.thirdparty.common;

import java.security.SecureRandom;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Random;
import javax.validation.ConstraintViolation;
import javax.validation.ConstraintViolationException;
import org.energyos.espi.thirdparty.common.ServiceCategoryDataOnDemand;
import org.energyos.espi.thirdparty.common.UsagePoint;
import org.energyos.espi.thirdparty.common.UsagePointDataOnDemand;
import org.energyos.espi.thirdparty.domain.AddressDataOnDemand;
import org.energyos.espi.thirdparty.domain.DataCustodianDataOnDemand;
import org.energyos.espi.thirdparty.domain.LocationDataOnDemand;
import org.energyos.espi.thirdparty.domain.RetailCustomerDataOnDemand;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

privileged aspect UsagePointDataOnDemand_Roo_DataOnDemand {
    
    declare @type: UsagePointDataOnDemand: @Component;
    
    private Random UsagePointDataOnDemand.rnd = new SecureRandom();
    
    private List<UsagePoint> UsagePointDataOnDemand.data;
    
    @Autowired
    private AddressDataOnDemand UsagePointDataOnDemand.addressDataOnDemand;
    
    @Autowired
    private DataCustodianDataOnDemand UsagePointDataOnDemand.dataCustodianDataOnDemand;
    
    @Autowired
    private LocationDataOnDemand UsagePointDataOnDemand.locationDataOnDemand;
    
    @Autowired
    private RetailCustomerDataOnDemand UsagePointDataOnDemand.retailCustomerDataOnDemand;
    
    @Autowired
    private ServiceCategoryDataOnDemand UsagePointDataOnDemand.serviceCategoryDataOnDemand;
    
    public UsagePoint UsagePointDataOnDemand.getNewTransientUsagePoint(int index) {
        UsagePoint obj = new UsagePoint();
        setDescription(obj, index);
        setRoleFlags(obj, index);
        setStatus(obj, index);
        setUuid(obj, index);
        return obj;
    }
    
    public void UsagePointDataOnDemand.setDescription(UsagePoint obj, int index) {
        String description = "description_" + index;
        obj.setDescription(description);
    }
    
    public void UsagePointDataOnDemand.setRoleFlags(UsagePoint obj, int index) {
        Short roleFlags = new Integer(index).shortValue();
        obj.setRoleFlags(roleFlags);
    }
    
    public void UsagePointDataOnDemand.setStatus(UsagePoint obj, int index) {
        Byte status = new Byte("1");
        obj.setStatus(status);
    }
    
    public void UsagePointDataOnDemand.setUuid(UsagePoint obj, int index) {
        String uuid = "uuid_" + index;
        obj.setUuid(uuid);
    }
    
    public UsagePoint UsagePointDataOnDemand.getSpecificUsagePoint(int index) {
        init();
        if (index < 0) {
            index = 0;
        }
        if (index > (data.size() - 1)) {
            index = data.size() - 1;
        }
        UsagePoint obj = data.get(index);
        Long id = obj.getId();
        return UsagePoint.findUsagePoint(id);
    }
    
    public UsagePoint UsagePointDataOnDemand.getRandomUsagePoint() {
        init();
        UsagePoint obj = data.get(rnd.nextInt(data.size()));
        Long id = obj.getId();
        return UsagePoint.findUsagePoint(id);
    }
    
    public boolean UsagePointDataOnDemand.modifyUsagePoint(UsagePoint obj) {
        return false;
    }
    
    public void UsagePointDataOnDemand.init() {
        int from = 0;
        int to = 10;
        data = UsagePoint.findUsagePointEntries(from, to);
        if (data == null) {
            throw new IllegalStateException("Find entries implementation for 'UsagePoint' illegally returned null");
        }
        if (!data.isEmpty()) {
            return;
        }
        
        data = new ArrayList<UsagePoint>();
        for (int i = 0; i < 10; i++) {
            UsagePoint obj = getNewTransientUsagePoint(i);
            try {
                obj.persist();
            } catch (ConstraintViolationException e) {
                StringBuilder msg = new StringBuilder();
                for (Iterator<ConstraintViolation<?>> iter = e.getConstraintViolations().iterator(); iter.hasNext();) {
                    ConstraintViolation<?> cv = iter.next();
                    msg.append("[").append(cv.getConstraintDescriptor()).append(":").append(cv.getMessage()).append("=").append(cv.getInvalidValue()).append("]");
                }
                throw new RuntimeException(msg.toString(), e);
            }
            obj.flush();
            data.add(obj);
        }
    }
    
}