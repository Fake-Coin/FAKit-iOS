//
//  BRChainParams.h
//
//  Created by Aaron Voisine on 1/10/18.
//  Copyright (c) 2019 breadwallet LLC
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

#ifndef BRChainParams_h
#define BRChainParams_h

#include "BRMerkleBlock.h"
#include <assert.h>

typedef struct {
    uint32_t height;
    UInt256 hash;
    uint32_t timestamp;
    uint32_t target;
} BRCheckPoint;

typedef struct {
    const char * const *dnsSeeds; // NULL terminated array of dns seeds
    uint16_t standardPort;
    uint32_t magicNumber;
    uint64_t services;
    int (*verifyDifficulty)(const BRMerkleBlock *block, const BRMerkleBlock *previous, uint32_t transitionTime);
    const BRCheckPoint *checkpoints;
    size_t checkpointsCount;
} BRChainParams;

static const char *BRMainNetDNSSeeds[] = {
    "seed.fakco.in",
    NULL
};

static const char *BRTestNetDNSSeeds[] = {
    "testnet-seed.ltc.xurious.com.",
    "seed-b.litecoin.loshan.co.uk.",
    "dnsseed-testnet.thrasher.io.",
    NULL
};

// blockchain checkpoints - these are also used as starting points for partial chain downloads, so they must be at
// difficulty transition boundaries in order to verify the block difficulty at the immediately following transition
static const BRCheckPoint BRMainNetCheckpoints[] = {
    {     0, "aec9203efaf5b35bdfc136477468830da578a1f5b21f4c59cf898dbb3fb17c33", 1512973198, 0x1e10024c },
    {     1, "8852898d57539ff7e065b16149d2097a37b41617b963d6002a7a00ecd1eeadc8", 1514518477, 0x1e10024c },
    {  2608, "22722429354af4f4ef8b9de55f0825611aa348d98fcb05d71e3c3adfaab4b94c", 1514547220, 0x1e10024c },
    {  5216, "9726ea3e333ca64e6cffa5fa9fe0e27338634890b36ad09b75c9c04eee59d423", 1514586552, 0x1e040093 },
    { 10432, "8c53c852c42c4ae1fad07c12cf8d259baf3ca873d24cac84cdf679d92dc6dcb6", 1514770971, 0x1d100240 },
    { 20864, "12e76ce3468f0c2fa8d53458ac69967faf88cc1e1d43641cf3f2afb55d2e363e", 1516044879, 0x1d0682e8 },
    { 32254, "340d0f58bc3e28e65a441be2e8557243230632dc81ed8cf65f6f0677a18eb6cb", 1517147316, 0x1d00f989 },
    { 41730, "c73361ab42465711db774796dce5686cefd8e44008638caaf02218a6ed4f75bb", 1520154717, 0x1d0512fa },
};

static const BRCheckPoint BRTestNetCheckpoints[] = {
    { 0, "4966625a4b2851d9fdee139e56211a0d88575f59ed816ff5e6a63deb4e3e29a0", 1486949366, 0x1e0ffff0 },
};

static int BRTestNetVerifyDifficulty(const BRMerkleBlock *block, const BRMerkleBlock *previous, uint32_t transitionTime)
{
    int r = 1;
    
    assert(block != NULL);
    assert(previous != NULL);
    
    if (! previous || !UInt256Eq(block->prevBlock, previous->blockHash) || block->height != previous->height + 1) r = 0;
    if (r && (block->height % BLOCK_DIFFICULTY_INTERVAL) == 0 && transitionTime == 0) r = 0;
    return r;
}

static const BRChainParams BRMainNetParams = {
    BRMainNetDNSSeeds,
    9333,       // standardPort
    0x3eafd13c, // magicNumber
    0,          // services
    BRMerkleBlockVerifyDifficulty,
    BRMainNetCheckpoints,
    sizeof(BRMainNetCheckpoints)/sizeof(*BRMainNetCheckpoints)
};

static const BRChainParams BRTestNetParams = {
    BRTestNetDNSSeeds,
    19333,      // standardPort
    0xf1c8d2fd, // magicNumber
    0,          // services
    BRTestNetVerifyDifficulty,
    BRTestNetCheckpoints,
    sizeof(BRTestNetCheckpoints)/sizeof(*BRTestNetCheckpoints)
};

#endif // BRChainParams_h
