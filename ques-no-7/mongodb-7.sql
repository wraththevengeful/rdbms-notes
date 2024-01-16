--// CUSTOMER Collection
db.createCollection("CUSTOMER", {
   validator: {
      $jsonSchema: {
         bsonType: "object",
         required: ["CID", "CNAME"],
         properties: {
            CID: { bsonType: "number" },
            CNAME: { bsonType: "string" }
         }
      }
   }
});
db.CUSTOMER.createIndex({ CID: 1 }, { unique: true });

--// BRANCH Collection
db.createCollection("BRANCH", {
   validator: {
      $jsonSchema: {
         bsonType: "object",
         required: ["BCODE", "BNAME"],
         properties: {
            BCODE: { bsonType: "number" },
            BNAME: { bsonType: "string" }
         }
      }
   }
});
db.BRANCH.createIndex({ BCODE: 1 }, { unique: true });

--// ACCOUNT Collection
db.createCollection("ACCOUNT", {
   validator: {
      $jsonSchema: {
         bsonType: "object",
         required: ["ANO", "ATYPE", "BALANCE", "CID", "BCODE"],
         properties: {
            ANO: { bsonType: "number" },
            ATYPE: { bsonType: "string", enum: ["S", "C"] },
            BALANCE: { bsonType: "number" },
            CID: { bsonType: "number" },
            BCODE: { bsonType: "number" }
         }
      }
   }
});
db.ACCOUNT.createIndex({ ANO: 1 }, { unique: true });
db.ACCOUNT.createIndex({ CID: 1 });
db.ACCOUNT.createIndex({ BCODE: 1 });

--// TRANSACTION Collection
db.createCollection("TRANSACTION", {
   validator: {
      $jsonSchema: {
         bsonType: "object",
         required: ["TID", "ANO", "TTYPE", "TTDATE", "TAMOUNT"],
         properties: {
            TID: { bsonType: "number" },
            ANO: { bsonType: "number" },
            TTYPE: { bsonType: "string", enum: ["D", "W"] },
            TTDATE: { bsonType: "date" },
            TAMOUNT: { bsonType: "number" }
         }
      }
   }
});
db.TRANSACTION.createIndex({ TID: 1 }, { unique: true });
db.TRANSACTION.createIndex({ ANO: 1 });

--c. MongoDB query to list the details of customers who have a savings account and a current account:

--b.

db.CUSTOMER.aggregate([
  {
    $lookup: {
      from: "ACCOUNT",
      let: { cid: "$CID" },
      pipeline: [
        {
          $match: {
            $expr: { $and: [{ $eq: ["$CID", "$$cid"] }, { $in: ["$ATYPE", ["S", "C"]] }] }
          }
        }
      ],
      as: "ACCOUNTS"
    }
  },
  {
    $match: {
      "ACCOUNTS": { $exists: true, $ne: [] }
    }
  },
  {
    $project: {
      CID: 1,
      CNAME: 1
    }
  }
]);

--d. MongoDB query to list the details of branches and the number of accounts in each branch:

db.BRANCH.aggregate([
  {
    $lookup: {
      from: "ACCOUNT",
      localField: "BCODE",
      foreignField: "BCODE",
      as: "ACCOUNTS"
    }
  },
  {
    $project: {
      BCODE: 1,
      BNAME: 1,
      NUM_ACCOUNTS: { $size: "$ACCOUNTS" }
    }
  }
]);


--e. MongoDB query to list the details of branches where the number of accounts is less than the average number of accounts in all branches:

var avgNumAccounts = db.ACCOUNT.aggregate([
  {
    $group: {
      _id: "$BCODE",
      avgNumAccounts: { $avg: 1 }
    }
  },
  {
    $group: {
      _id: null,
      overallAvg: { $avg: "$avgNumAccounts" }
    }
  },
  {
    $project: {
      _id: 0,
      overallAvg: 1
    }
  }
]).next().overallAvg;

db.BRANCH.aggregate([
  {
    $lookup: {
      from: "ACCOUNT",
      localField: "BCODE",
      foreignField: "BCODE",
      as: "ACCOUNTS"
    }
  },
  {
    $project: {
      BCODE: 1,
      BNAME: 1,
      NUM_ACCOUNTS: { $size: "$ACCOUNTS" }
    }
  },
  {
    $match: {
      NUM_ACCOUNTS: { $lt: avgNumAccounts }
    }
  }
]);


--f. MongoDB query to list the details of customers who have performed three transactions on a day:

var customersWithThreeTransactions = db.TRANSACTION.aggregate([
  {
    $group: {
      _id: "$ANO",
      TTDATEs: { $addToSet: "$TTDATE" },
      transactionCount: { $sum: 1 }
    }
  },
  {
    $match: {
      transactionCount: 3
    }
  },
  {
    $lookup: {
      from: "ACCOUNT",
      localField: "_id",
      foreignField: "ANO",
      as: "ACCOUNT"
    }
  },
  {
    $unwind: "$ACCOUNT"
  },
  {
    $lookup: {
      from: "CUSTOMER",
      localField: "ACCOUNT.CID",
      foreignField: "CID",
      as: "CUSTOMER"
    }
  },
  {
    $unwind: "$CUSTOMER"
  },
  {
    $project: {
      CID: "$CUSTOMER.CID",
      CNAME: "$CUSTOMER.CNAME"
    }
  }
]);


