--// DEPARTMENT Collection
db.createCollection("DEPARTMENT", {
   validator: {
      $jsonSchema: {
         bsonType: "object",
         required: ["DEPT_NO", "NAME", "MENO"],
         properties: {
            DEPT_NO: { bsonType: "number" },
            NAME: { bsonType: "string" },
            MENO: { bsonType: "number" }
         }
      }
   }
});
db.DEPARTMENT.createIndex({ DEPT_NO: 1 }, { unique: true });
db.DEPARTMENT.createIndex({ MENO: 1 });

--// EMPLOYEE Collection
db.createCollection("EMPLOYEE", {
   validator: {
      $jsonSchema: {
         bsonType: "object",
         required: ["ENO", "NAME", "GENDER", "DOB", "DOJ", "DESIGNATION", "BASIC", "DEPT_NO", "PAN", "SENO"],
         properties: {
            ENO: { bsonType: "number" },
            NAME: { bsonType: "string" },
            GENDER: { bsonType: "string" },
            DOB: { bsonType: "date" },
            DOJ: { bsonType: "date" },
            DESIGNATION: { bsonType: "string" },
            BASIC: { bsonType: "decimal" },
            DEPT_NO: { bsonType: "number" },
            PAN: { bsonType: "string" },
            SENO: { bsonType: "number" }
         }
      }
   }
});
db.EMPLOYEE.createIndex({ ENO: 1 }, { unique: true });
db.EMPLOYEE.createIndex({ DEPT_NO: 1 });
db.EMPLOYEE.createIndex({ SENO: 1 });
db.EMPLOYEE.createIndex({ PAN: 1 });

--// PROJECT Collection
db.createCollection("PROJECT", {
   validator: {
      $jsonSchema: {
         bsonType: "object",
         required: ["PROJ_NO", "NAME", "DEPT_NO"],
         properties: {
            PROJ_NO: { bsonType: "number" },
            NAME: { bsonType: "string" },
            DEPT_NO: { bsonType: "number" }
         }
      }
   }
});
db.PROJECT.createIndex({ PROJ_NO: 1 }, { unique: true });
db.PROJECT.createIndex({ DEPT_NO: 1 });

--// WORKSFOR Collection
db.createCollection("WORKSFOR", {
   validator: {
      $jsonSchema: {
         bsonType: "object",
         required: ["ENO", "PROJ_NO", "DATE_WORKED", "HOURS"],
         properties: {
            ENO: { bsonType: "number" },
            PROJ_NO: { bsonType: "number" },
            DATE_WORKED: { bsonType: "date" },
            HOURS: { bsonType: "number" }
         }
      }
   }
});
db.WORKSFOR.createIndex({ ENO: 1, PROJ_NO: 1, DATE_WORKED: 1 }, { unique: true });
db.WORKSFOR.createIndex({ ENO: 1 });
db.WORKSFOR.createIndex({ PROJ_NO: 1 });



--c. MongoDB query to list departments and details of the manager in each department:


db.DEPARTMENT.aggregate([
  {
    $lookup: {
      from: "EMPLOYEE",
      localField: "MENO",
      foreignField: "ENO",
      as: "MANAGER"
    }
  },
  {
    $unwind: "$MANAGER"
  },
  {
    $project: {
      DEPT_NO: 1,
      NAME: 1,
      MANAGER_NAME: "$MANAGER.NAME"
    }
  }
]);


--d. MongoDB query to list details of all employees and the details of their supervisors:


db.EMPLOYEE.aggregate([
  {
    $lookup: {
      from: "EMPLOYEE",
      localField: "SENO",
      foreignField: "ENO",
      as: "SUPERVISOR"
    }
  },
  {
    $unwind: { path: "$SUPERVISOR", preserveNullAndEmptyArrays: true }
  },
  {
    $project: {
      ENO: 1,
      NAME: 1,
      SUPERVISOR_NAME: "$SUPERVISOR.NAME"
    }
  }
]);


--e. MongoDB query to list department number, department name, and the number of employees in each department:


db.DEPARTMENT.aggregate([
  {
    $lookup: {
      from: "EMPLOYEE",
      localField: "DEPT_NO",
      foreignField: "DEPT_NO",
      as: "EMPLOYEES"
    }
  },
  {
    $project: {
      DEPT_NO: 1,
      NAME: 1,
      NUM_EMPLOYEES: { $size: "$EMPLOYEES" }
    }
  }
]);



--f. MongoDB query to list details of employees earning less than the average basic pay of all employees:

var avgBasicPay = db.EMPLOYEE.aggregate([
  {
    $group: {
      _id: null,
      avgBasicPay: { $avg: "$BASIC" }
    }
  },
  {
    $project: {
      _id: 0,
      avgBasicPay: 1
    }
  }
]).next().avgBasicPay;

db.EMPLOYEE.find({ BASIC: { $lt: avgBasicPay } });

--//HANDLE WHEN VAUES ARE NULL:

var result = db.EMPLOYEE.aggregate([
  {
    $group: {
      _id: null,
      avgBasicPay: { $avg: "$BASIC" }
    }
  },
  {
    $project: {
      _id: 0,
      avgBasicPay: 1
    }
  }
]).next();

var avgBasicPay = result ? result.avgBasicPay : null;

print("Average Basic Pay:", avgBasicPay);





--g. MongoDB query to list details of departments with more than six employees:


db.DEPARTMENT.aggregate([
  {
    $lookup: {
      from: "EMPLOYEE",
      localField: "DEPT_NO",
      foreignField: "DEPT_NO",
      as: "EMPLOYEES"
    }
  },
  {
    $project: {
      DEPT_NO: 1,
      NAME: 1,
      NUM_EMPLOYEES: { $size: "$EMPLOYEES" }
    }
  },
  {
    $match: {
      NUM_EMPLOYEES: { $gt: 6 }
    }
  }
]);