const crypto = require('crypto');

class TouristBlockchain {
  constructor() {
    this.chain = [];
    this.createGenesisBlock();
  }

  createGenesisBlock() {
    const genesisBlock = {
      index: 0,
      timestamp: Date.now(),
      data: "Tourist Safety Genesis Block",
      previousHash: "0",
      hash: this.calculateHash(0, Date.now(), "Tourist Safety Genesis Block", "0"),
      nonce: 0
    };
    this.chain.push(genesisBlock);
  }

  calculateHash(index, timestamp, data, previousHash, nonce = 0) {
    return crypto
      .createHash('sha256')
      .update(index + timestamp + JSON.stringify(data) + previousHash + nonce)
      .digest('hex');
  }

  addTouristRecord(touristData) {
    const lastBlock = this.chain[this.chain.length - 1];
    const newBlock = {
      index: lastBlock.index + 1,
      timestamp: Date.now(),
      data: {
        ...touristData,
        type: 'TOURIST_REGISTRATION'
      },
      previousHash: lastBlock.hash,
      nonce: 0
    };

    // Simple proof of work
    while (newBlock.hash === undefined || !newBlock.hash.startsWith('000')) {
      newBlock.nonce++;
      newBlock.hash = this.calculateHash(
        newBlock.index,
        newBlock.timestamp,
        newBlock.data,
        newBlock.previousHash,
        newBlock.nonce
      );
    }

    this.chain.push(newBlock);
    return newBlock.hash;
  }

  addAlertRecord(alertData) {
    const lastBlock = this.chain[this.chain.length - 1];
    const newBlock = {
      index: lastBlock.index + 1,
      timestamp: Date.now(),
      data: {
        ...alertData,
        type: 'SECURITY_ALERT'
      },
      previousHash: lastBlock.hash,
      nonce: 0
    };

    // Simple proof of work
    while (newBlock.hash === undefined || !newBlock.hash.startsWith('000')) {
      newBlock.nonce++;
      newBlock.hash = this.calculateHash(
        newBlock.index,
        newBlock.timestamp,
        newBlock.data,
        newBlock.previousHash,
        newBlock.nonce
      );
    }

    this.chain.push(newBlock);
    return newBlock.hash;
  }

  verifyTouristId(digitalId) {
    return this.chain.find(block => 
      block.data.digitalId === digitalId && block.data.type === 'TOURIST_REGISTRATION'
    );
  }

  verifyChainIntegrity() {
    for (let i = 1; i < this.chain.length; i++) {
      const currentBlock = this.chain[i];
      const previousBlock = this.chain[i - 1];

      if (currentBlock.hash !== this.calculateHash(
        currentBlock.index,
        currentBlock.timestamp,
        currentBlock.data,
        currentBlock.previousHash,
        currentBlock.nonce
      )) {
        return false;
      }

      if (currentBlock.previousHash !== previousBlock.hash) {
        return false;
      }
    }
    return true;
  }

  getChainLength() {
    return this.chain.length;
  }

  getTouristHistory(digitalId) {
    return this.chain.filter(block => 
      block.data.digitalId === digitalId
    );
  }
}

// Export a singleton instance so routes can call methods directly
module.exports = new TouristBlockchain();