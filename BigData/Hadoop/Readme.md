# Hadoop

Hadoop is an open-source framework that is designed for the distributed storage and processing of large datasets across clusters of computers using simple programming models. It's reliable for handling large-scale batch processing but is less flexible for real-time data processing.


The Hadoop framework mainly consists of 3 components
- Storage ----------------> HDFS 
- Processing -------------> Map Reduce
- Resource Manager-----> YARN (Yet Another Resource Negotiator)

## HDFS (Hadoop Distribution File System)
HDFS is a core component of the Apache Hadoop ecosystem designed to store and manage vast amounts of data across a distributed cluster of commodity hardware in a reliable, scalable, and efficient way. It is inspired by the Google File System (GFS) and is highly fault-tolerant, able to work even when individual nodes fail.

**Key Features**:
 - **Distributed Storage** ---> Data is divided into large blocks (typically 128 MB or 256 MB) and spread across multiple nodes in the cluster.
 - **Scalability** ---> The system can easily scale out by adding more nodes to the cluster. It is designed to handle petabytes and beyond.
 - **Fault Tolerance** ---> Each block of data is replicated (by default, 3 copies) across nodes to ensure fault tolerance and reliability
 - **High Throughput Access** ---> HDFS is optimized for large-scale reads and writes, prioritizing throughput over latency.

FYI: 
- A `Node` is simply a computer (a physical or virtual server)
- A `Cluster` in Hadoop refers to a collection of interconnected nodes
- A `Block` is When a file is uploaded to HDFS, it is split into fixed-size blocks
   
**Architecture Components of HDFS**:
 1. **NameNode:**
    - Acts as the master server and manages the file system’s namespace and metadata. Keeps track of where data is located in the cluster but does not store the actual data. a single point of failure, but modern HDFS setups often have a secondary or backup NameNode for fault tolerance.
 2. **DataNodes:**
    - Serve as the "workers" in the cluster, storing the actual data blocks. handles read and write requests from clients.
 3. **Secondary NameNode:**
    - Not a backup for the NameNode but a helper that performs housekeeping functions like checkpointing the metadata. helps in reducing the load on the primary NameNode.

**Workflow of HDFS:**
 1. **Writing a File:**
    - When a file is written to HDFS, it is split into blocks.
    - These blocks are distributed and replicated across DataNodes based on the replication factor.
    - The NameNode keeps track of the block locations and manages the file structure.
 2. **Reading a File:**
    - When a client wants to read a file, it contacts the NameNode for metadata and block locations.
    - The client then retrieves the blocks directly from the DataNodes and reconstructs the file.
      
**Example:** (Let’s walk through the process of how HDFS stores 1 GB of data step-by-step)
- **Step 1: File Splitting into Blocks**
    - When you have a 1 GB file and you want to store it in HDFS, the first thing that happens is the file is split into blocks.
    - HDFS has a default block size of 128 MB (though it can be configured). Therefore, a 1 GB file will be split into approximately 8 blocks:
      - Block 1: 128 MB
      - Block 2: 128 MB
      - ...
      - Block 8: 128 MB
    - Each block is treated as an independent unit of storage.
- **Step 2: Replication for Fault Tolerance**
    - HDFS maintains replication for reliability. By default, each block is replicated 3 times (replication factor = 3) across different nodes in the cluster.
    - So, each of the 8 blocks will have 3 copies distributed across the cluster's DataNodes, resulting in a total of 24 block copies (8 blocks * 3 replicas).
- **Step 3: Storing Blocks on DataNodes**
    - The NameNode (master node) manages the metadata and knows where each block is stored. It does not store the actual data but keeps a map of blocks and their corresponding DataNodes.
    - Each block is stored across different DataNodes for reliability and to ensure data availability even if some nodes fail.
      - For instance, Block 1 might be stored on DataNode A, DataNode B, and DataNode C.
      - Block 2 could be on DataNode D, DataNode E, and DataNode F, and so on.
- **Step 4: Writing Data to DataNodes**
    - The client (user or application uploading the file) interacts with the NameNode to begin writing the blocks.
      - The client requests the NameNode for information on where to store each block.
      - The NameNode provides a list of DataNodes for each block, ensuring that the replicas are distributed across the cluster.
    - The client then directly writes the data blocks to the designated DataNodes.
      - During this process, each block is written to the first DataNode, which then replicates it to the second DataNode, and the second to the third DataNode.
    - Once all blocks are written and replicated across DataNodes, the DataNodes send an acknowledgment to the NameNode.
    - The NameNode updates its metadata to reflect the locations and replicas of each block, effectively completing the storage process.
 
**Summary**
- A 1 GB file is split into 8 blocks of 128 MB each.
- Each block is replicated 3 times (total of 24 block copies).
- Blocks are distributed and stored on various DataNodes.
- The NameNode manages the block-to-DataNode mapping and metadata for access.

## Map Reduce

MapReduce is a programming model and a processing technique used within the Hadoop ecosystem for handling large-scale data processing in a distributed environment. It divides the task into two main phases — the "Map" phase and the "Reduce" phase — which can be processed in parallel across many nodes in a cluster, making it highly scalable and efficient for batch processing.

**Key Features**:
1. **Input Data**
   - The data to be processed is stored in HDFS. It is generally a large file that has been split into blocks.
   - This file serves as the input for the MapReduce job.

2. **Splitting and Assigning Input Splits**
   - The MapReduce framework divides the input data into splits, which are typically the same size as the HDFS block (e.g., 128 MB).
   - Each split is assigned to a Mapper task, which is responsible for processing that chunk of data.
   
3. **Map Phase:**
   - Mappers are worker nodes that process the data in parallel. A Mapper processes each input split line-by-line (or in chunks of data).
   - For each input record, the Mapper performs a map function, which is a user-defined operation that processes the data and converts it into a key-value pair.
   - For example, if you're counting word occurrences in a text, the sentence "hello world hello" would be transformed by the Mapper into:
```
(hello, 1), (world, 1), (hello, 1)
```
 - The Mapper outputs these key-value pairs, which are intermediate data.
   
4. **Shuffle and Sort Phase:**
   - After the Map phase is complete, the framework automatically groups together all the values for the same key. This is called Shuffling and Sorting. 
   - This step ensures that data is grouped and transferred to the appropriate "Reduce" tasks.
   - The goal is to combine all similar keys from different Mappers together so that they can be processed by the same Reducer.
```
(hello, [1, 1]), (world, [1])
```

5. **Reduce Phase:**
   - Reducers are worker nodes responsible for aggregating the intermediate data generated by Mappers.
     - The framework assigns each group of similar keys (from the Shuffle step) to a specific Reducer.
   - The Reducer applies a reduce function to the values of each key to produce a final result.
     - Example: For the word count example, the Reducer would sum up all the counts of each word:
```
(hello, 2), (world, 1)
```

6. **Output Phase:**
   - The final output of the Reduce phase is written back to HDFS.
   - Each Reducer writes its output in the form of key-value pairs into output files
   - This final output can then be used for further processing or analysis.

**Summary of the Workflow**
1. Input Data Splitting: The input data is split into chunks for parallel processing.
2. Mapping: The Map function processes each split and produces key-value pairs.
3. Shuffling and Sorting: The intermediate key-value pairs are grouped by key.
4. Reducing: The Reduce function aggregates values for each key to produce the final output.
5. Output Data: The result is saved back into HDFS.

**Example:** (Let’s walk through the process of how Map Reduce works on Word Count step-by-step)
- Input File: "hello world hello"
- Map Phase: Each line of text is processed by a Mapper.
  - Output: `(hello, 1), (world, 1), (hello, 1)`
- Shuffle and Sort: Intermediate data is grouped by key.
  - Grouped Output: `(hello, [1, 1]), (world, [1])`
- Reduce Phase: Reducers sum the values for each key.
  - Final Output: `(hello, 2), (world, 1)`
 
 ## YARN (Yet Another Resource Negotiator)

YARN is a core component of the Hadoop ecosystem, designed to manage and schedule resources in a Hadoop cluster efficiently. It acts as a resource management layer, separating resource management and job scheduling from data processing, thereby enhancing scalability and resource utilization. Here's a breakdown of how YARN works:

**Key Components of YARN**
1. **Resource Manager (RM)**
   - The master daemon is responsible for resource allocation and scheduling across the cluster.
   - The RM has two main parts:
     - Scheduler: Allocates resources to running applications based on policies like capacity or fairness. It does not monitor the progress of the applications.
     - Application Manager (AM): Manages the lifecycle of each application (like a MapReduce job), negotiates resources from the Scheduler, and works with the NodeManager to execute and monitor tasks.

2. **Node Manager (NM)**
   - Runs on each node (worker machine) in the Hadoop cluster.
   - Responsible for managing the resources on a single node, monitoring the health of the node, and reporting resource usage back to the RM.
   - It launches and manages containers on that node based on the requests it receives from the RM.

3. **Application Master (AM)**
   - An AM is created for each application submitted to YARN.
   - Responsible for negotiating resources from the Resource Manager and working with the Node Managers to execute and monitor the application tasks.
   - For a MapReduce job, the AM will coordinate the execution of Map and Reduce tasks by requesting resources and tracking their progress.

4. **Container**
   - The basic unit of resource allocation in YARN, encapsulates memory, CPU, and other resources needed to run an application task.
   - Each container is managed by the Node Manager, which launches and monitors the container as per instructions from the Application Master.

**How YARN Works: Step-by-Step Process**

1. **Job Submission**
   - A client submits an application (e.g., a MapReduce job) to the Resource Manager (RM).
   - The application submission includes the Application Master (AM) code and details about the resource requirements.

2. **Starting the Application Master**
   - The Resource Manager schedules a container to run the Application Master (AM) on one of the nodes.
   - The AM is responsible for coordinating the application’s execution.

3. **Resource Allocation for Tasks**
   - The Application Master requests additional containers from the Resource Manager to execute the tasks of the application (e.g., Map and Reduce tasks in a MapReduce job).
   - The Resource Manager allocates containers based on availability and policies, and the AM works with Node Managers to launch these containers.

4. **Task Execution in Containers**
   - Containers are launched by Node Managers (NM) on various nodes in the cluster.
   - Each container runs a portion of the application's tasks, such as a Map or Reduce function in the case of MapReduce.

5. **Monitoring and Completion**
   - The Application Master monitors the progress of all containers and tasks.
   - If a task fails, the AM can request new containers to re-run the failed task.
   - Once all tasks are complete, the AM notifies the Resource Manager, which cleans up and releases resources.

6. **Resource Management and Optimization**
   - The Resource Manager continuously manages the cluster’s resources and optimizes the allocation based on usage, ensuring efficient utilization of nodes.

**Summary of YARN's Role**

- Efficient Resource Utilization: By decoupling resource management and job scheduling from the processing model, YARN enables multiple data processing engines (not just MapReduce) to share a Hadoop cluster.
- Scalability: It allows for improved scalability by dynamically allocating resources based on needs.
- Fault Tolerance: It can handle node failures gracefully by redistributing tasks to other healthy nodes.

 ## Challenges of Hadoop
1. Processing Transactions (Random Access)
2. When work can't be parallelized
3. when there are dependencies in the data (Dependencies arise when record one must be processed before record two)
4. Hadoop is also not good for low-latency data access. (“Low latency” allows small delays, unnoticeable to humans, between an input being processed and the corresponding output providing real-time characteristics.)
5. Processing lots of small files
6. intensive calculations with little data
7. Not good for real time processing but really good for batch processing

To deal with the shortcomings of Hadoop, new tools like Hive were built on top of Hadoop. Hive provided SQL-like query and provided users with strong statistical functions. Pig was popular for its multi query approach to cut down the number of times that the data is scanned.
