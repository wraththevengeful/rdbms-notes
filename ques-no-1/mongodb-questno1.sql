--Certainly! Here is the collection creation query for the "EMPLOYEE" table in the format you provided:

db.createCollection("EMPLOYEE", {
   validator: {
      $jsonSchema: {
         bsonType: "object",
         required: ["STAFFNO", "NAME", "GENDER", "BASIC_PAY", "DEPTNO"],
         properties: {
            STAFFNO: { bsonType: "number" },
            NAME: { bsonType: "string" },
            GENDER: { bsonType: "string" },
            DOB: { bsonType: "date" },
            DOJ: { bsonType: "date" },
            DESIGNATION: { bsonType: "string" },
            BASIC_PAY: { bsonType: "number" },
            DEPTNO: { bsonType: "number" }
         }
      }
   }
});

--STAFF Collection:

db.createCollection("STAFF", {
   validator: {
      $jsonSchema: {
         bsonType: "object",
         required: ["STAFFNO", "NAME", "GENDER", "DOJ", "BASIC_PAY", "DEPTNO"],
         properties: {
            STAFFNO: { bsonType: "number" },
            NAME: { bsonType: "string" },
            DOB: { bsonType: "date" },
            GENDER: { bsonType: "string" },
            DOJ: { bsonType: "date" },
            DESIGNATION: { bsonType: "string" },
            BASIC_PAY: { bsonType: "number" },
            DEPTNO: { bsonType: "number" }
         }
      }
   }
});

--DEPT Collection:

db.createCollection("DEPT", {
   validator: {
      $jsonSchema: {
         bsonType: "object",
         required: ["DEPTNO", "NAME"],
         properties: {
            DEPTNO: { bsonType: "number" },
            NAME: { bsonType: "string" }
         }
      }
   }
});

--SKILL Collection:

db.createCollection("SKILL", {
   validator: {
      $jsonSchema: {
         bsonType: "object",
         required: ["SKILL_CODE", "DESCRIPTION", "CHARGE_OUTRATE"],
         properties: {
            SKILL_CODE: { bsonType: "number" },
            DESCRIPTION: { bsonType: "string" },
            CHARGE_OUTRATE: { bsonType: "number" }
         }
      }
   }
});

--STAFF_SKILL Collection:

db.createCollection("STAFF_SKILL", {
   validator: {
      $jsonSchema: {
         bsonType: "object",
         required: ["STAFFNO", "SKILL_CODE"],
         properties: {
            STAFFNO: { bsonType: "number" },
            SKILL_CODE: { bsonType: "number" }
         }
      }
   }
});


--PROJECT Collection:

db.createCollection("PROJECT", {
   validator: {
      $jsonSchema: {
         bsonType: "object",
         required: ["PROJECTNO", "PNAME", "START_DATE", "END_DATE", "BUDGET", "PROJECT_MANAGER", "STAFFNO"],
         properties: {
            PROJECTNO: { bsonType: "number" },
            PNAME: { bsonType: "string" },
            START_DATE: { bsonType: "date" },
            END_DATE: { bsonType: "date" },
            BUDGET: { bsonType: "number" },
            PROJECT_MANAGER: { bsonType: "string" },
            STAFFNO: { bsonType: "number" }
         }
      }
   }
});


--WORKS Collection:

db.createCollection("WORKS", {
   validator: {
      $jsonSchema: {
         bsonType: "object",
         required: ["STAFFNO", "PROJECTNO", "DATE_WORKED_ON", "IN_TIME", "OUT_TIME"],
         properties: {
            STAFFNO: { bsonType: "number" },
            PROJECTNO: { bsonType: "number" },
            DATE_WORKED_ON: { bsonType: "date" },
            IN_TIME: { bsonType: "date" },
            OUT_TIME: { bsonType: "date" }
         }
      }
   }
});



--c.


db.STAFF.aggregate([
    {
        $group: {
            _id: "$DEPTNO",
            NUM_OF_STAFF: { $sum: 1 }
        }
    },
    {
        $project: {
            DEPTNO: "$_id",
            NUM_OF_STAFF: 1,
            _id: 0
        }
    }
]);




--d.


var avgBasicPay = db.STAFF.aggregate([
    {
        $group: {
            _id: null,
            avgBasicPay: { $avg: "$BASIC_PAY" }
        }
    },
    {
        $project: {
            _id: 0,
            avgBasicPay: 1
        }
    }
]).next().avgBasicPay;

db.STAFF.find({ BASIC_PAY: { $lt: avgBasicPay } });

//DIDNT WORK WITH NULL VALUES SO USING THIS:

var result = db.STAFF.aggregate([
  {
    $match: { BASIC_PAY: { $ne: null } }
  },
  {
    $group: {
      _id: null,
      avgBasicPay: { $avg: "$BASIC_PAY" }
    }
  },
  {
    $project: { _id: 0, avgBasicPay: 1 }
  }
]).next();

var avgBasicPay = result ? result.avgBasicPay : null;

print("Average Basic Pay:", avgBasicPay);



--e.


db.DEPT.aggregate([
    {
        $lookup: {
            from: "STAFF",
            localField: "DEPTNO",
            foreignField: "DEPTNO",
            as: "staffData"
        }
    },
    {
        $unwind: "$staffData"
    },
    {
        $group: {
            _id: "$DEPTNO",
            DEPT: { $first: "$$ROOT" },
            NUM_OF_STAFF: { $sum: 1 }
        }
    },
    {
        $match: {
            NUM_OF_STAFF: { $gt: 5 }
        }
    },
    {
        $replaceRoot: { newRoot: "$DEPT" }
    }
]);



--f.


db.STAFF.aggregate([
    {
        $lookup: {
            from: "STAFF_SKILL",
            localField: "STAFFNO",
            foreignField: "STAFFNO",
            as: "skillsData"
        }
    },
    {
        $unwind: "$skillsData"
    },
    {
        $group: {
            _id: "$STAFFNO",
            STAFF: { $first: "$$ROOT" },
            NUM_OF_SKILLS: { $sum: 1 }
        }
    },
    {
        $match: {
            NUM_OF_SKILLS: { $gt: 3 }
        }
    },
    {
        $replaceRoot: { newRoot: "$STAFF" }
    }
]);




--g.


db.STAFF.aggregate([
    {
        $lookup: {
            from: "STAFF_SKILL",
            localField: "STAFFNO",
            foreignField: "STAFFNO",
            as: "skillsData"
        }
    },
    {
        $unwind: "$skillsData"
    },
    {
        $lookup: {
            from: "SKILL",
            localField: "skillsData.SKILL_CODE",
            foreignField: "SKILL_CODE",
            as: "skillDetails"
        }
    },
    {
        $unwind: "$skillDetails"
    },
    {
        $match: {
            "skillDetails.CHARGE_OUTRATE": { $gt: 60 }
        }
    },
    {
        $project: {
            skillsData: 0, // Exclude skillsData from the final output
            skillDetails: 0 // Exclude skillDetails from the final output
        }
    }
]);








 



