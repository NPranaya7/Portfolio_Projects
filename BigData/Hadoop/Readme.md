# Hadoop

Hadoop is an open-source framework that is designed for the distributed storage and processing of large datasets across clusters of computers using simple programming models. It's reliable for handling large-scale batch processing but is less flexible for real-time data processing.


The Hadoop framework mainly consists of 3 components
- Storage ----------------> HDFS 
- Processing -------------> Map Reduce
- Resource Manager-----> YARN (Yet Another Resource Negotiator)

## HDFS (Hadoop Distribution File System)
It is a core component of the Apache Hadoop ecosystem designed to store and manage vast amounts of data across a distributed cluster of commodity hardware in a reliable, scalable, and efficient way. It is inspired by the Google File System (GFS) and is highly fault-tolerant, able to work even when individual nodes fail.

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
