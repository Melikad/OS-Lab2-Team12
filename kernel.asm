
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 90 10 00       	mov    $0x109000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc e0 b5 10 80       	mov    $0x8010b5e0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 60 32 10 80       	mov    $0x80103260,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax
80100034:	66 90                	xchg   %ax,%ax
80100036:	66 90                	xchg   %ax,%ax
80100038:	66 90                	xchg   %ax,%ax
8010003a:	66 90                	xchg   %ax,%ax
8010003c:	66 90                	xchg   %ax,%ax
8010003e:	66 90                	xchg   %ax,%ax

80100040 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100040:	f3 0f 1e fb          	endbr32 
80100044:	55                   	push   %ebp
80100045:	89 e5                	mov    %esp,%ebp
80100047:	53                   	push   %ebx

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100048:	bb 14 b6 10 80       	mov    $0x8010b614,%ebx
{
8010004d:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
80100050:	68 80 73 10 80       	push   $0x80107380
80100055:	68 e0 b5 10 80       	push   $0x8010b5e0
8010005a:	e8 b1 45 00 00       	call   80104610 <initlock>
  bcache.head.next = &bcache.head;
8010005f:	83 c4 10             	add    $0x10,%esp
80100062:	b8 dc fc 10 80       	mov    $0x8010fcdc,%eax
  bcache.head.prev = &bcache.head;
80100067:	c7 05 2c fd 10 80 dc 	movl   $0x8010fcdc,0x8010fd2c
8010006e:	fc 10 80 
  bcache.head.next = &bcache.head;
80100071:	c7 05 30 fd 10 80 dc 	movl   $0x8010fcdc,0x8010fd30
80100078:	fc 10 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
8010007b:	eb 05                	jmp    80100082 <binit+0x42>
8010007d:	8d 76 00             	lea    0x0(%esi),%esi
80100080:	89 d3                	mov    %edx,%ebx
    b->next = bcache.head.next;
80100082:	89 43 54             	mov    %eax,0x54(%ebx)
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
80100085:	83 ec 08             	sub    $0x8,%esp
80100088:	8d 43 0c             	lea    0xc(%ebx),%eax
    b->prev = &bcache.head;
8010008b:	c7 43 50 dc fc 10 80 	movl   $0x8010fcdc,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 87 73 10 80       	push   $0x80107387
80100097:	50                   	push   %eax
80100098:	e8 33 44 00 00       	call   801044d0 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 30 fd 10 80       	mov    0x8010fd30,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	8d 93 5c 02 00 00    	lea    0x25c(%ebx),%edx
801000a8:	83 c4 10             	add    $0x10,%esp
    bcache.head.next->prev = b;
801000ab:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
801000ae:	89 d8                	mov    %ebx,%eax
801000b0:	89 1d 30 fd 10 80    	mov    %ebx,0x8010fd30
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	81 fb 80 fa 10 80    	cmp    $0x8010fa80,%ebx
801000bc:	75 c2                	jne    80100080 <binit+0x40>
  }
}
801000be:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801000c1:	c9                   	leave  
801000c2:	c3                   	ret    
801000c3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801000ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801000d0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000d0:	f3 0f 1e fb          	endbr32 
801000d4:	55                   	push   %ebp
801000d5:	89 e5                	mov    %esp,%ebp
801000d7:	57                   	push   %edi
801000d8:	56                   	push   %esi
801000d9:	53                   	push   %ebx
801000da:	83 ec 18             	sub    $0x18,%esp
801000dd:	8b 7d 08             	mov    0x8(%ebp),%edi
801000e0:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&bcache.lock);
801000e3:	68 e0 b5 10 80       	push   $0x8010b5e0
801000e8:	e8 a3 46 00 00       	call   80104790 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000ed:	8b 1d 30 fd 10 80    	mov    0x8010fd30,%ebx
801000f3:	83 c4 10             	add    $0x10,%esp
801000f6:	81 fb dc fc 10 80    	cmp    $0x8010fcdc,%ebx
801000fc:	75 0d                	jne    8010010b <bread+0x3b>
801000fe:	eb 20                	jmp    80100120 <bread+0x50>
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb dc fc 10 80    	cmp    $0x8010fcdc,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 7b 04             	cmp    0x4(%ebx),%edi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 73 08             	cmp    0x8(%ebx),%esi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010011f:	90                   	nop
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 2c fd 10 80    	mov    0x8010fd2c,%ebx
80100126:	81 fb dc fc 10 80    	cmp    $0x8010fcdc,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 70                	jmp    801001a0 <bread+0xd0>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb dc fc 10 80    	cmp    $0x8010fcdc,%ebx
80100139:	74 65                	je     801001a0 <bread+0xd0>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010013b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010013e:	85 c0                	test   %eax,%eax
80100140:	75 ee                	jne    80100130 <bread+0x60>
80100142:	f6 03 04             	testb  $0x4,(%ebx)
80100145:	75 e9                	jne    80100130 <bread+0x60>
      b->dev = dev;
80100147:	89 7b 04             	mov    %edi,0x4(%ebx)
      b->blockno = blockno;
8010014a:	89 73 08             	mov    %esi,0x8(%ebx)
      b->flags = 0;
8010014d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
80100153:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
8010015a:	83 ec 0c             	sub    $0xc,%esp
8010015d:	68 e0 b5 10 80       	push   $0x8010b5e0
80100162:	e8 e9 46 00 00       	call   80104850 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 9e 43 00 00       	call   80104510 <acquiresleep>
      return b;
80100172:	83 c4 10             	add    $0x10,%esp
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	74 0e                	je     80100188 <bread+0xb8>
    iderw(b);
  }
  return b;
}
8010017a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010017d:	89 d8                	mov    %ebx,%eax
8010017f:	5b                   	pop    %ebx
80100180:	5e                   	pop    %esi
80100181:	5f                   	pop    %edi
80100182:	5d                   	pop    %ebp
80100183:	c3                   	ret    
80100184:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    iderw(b);
80100188:	83 ec 0c             	sub    $0xc,%esp
8010018b:	53                   	push   %ebx
8010018c:	e8 0f 23 00 00       	call   801024a0 <iderw>
80100191:	83 c4 10             	add    $0x10,%esp
}
80100194:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100197:	89 d8                	mov    %ebx,%eax
80100199:	5b                   	pop    %ebx
8010019a:	5e                   	pop    %esi
8010019b:	5f                   	pop    %edi
8010019c:	5d                   	pop    %ebp
8010019d:	c3                   	ret    
8010019e:	66 90                	xchg   %ax,%ax
  panic("bget: no buffers");
801001a0:	83 ec 0c             	sub    $0xc,%esp
801001a3:	68 8e 73 10 80       	push   $0x8010738e
801001a8:	e8 e3 01 00 00       	call   80100390 <panic>
801001ad:	8d 76 00             	lea    0x0(%esi),%esi

801001b0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001b0:	f3 0f 1e fb          	endbr32 
801001b4:	55                   	push   %ebp
801001b5:	89 e5                	mov    %esp,%ebp
801001b7:	53                   	push   %ebx
801001b8:	83 ec 10             	sub    $0x10,%esp
801001bb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001be:	8d 43 0c             	lea    0xc(%ebx),%eax
801001c1:	50                   	push   %eax
801001c2:	e8 e9 43 00 00       	call   801045b0 <holdingsleep>
801001c7:	83 c4 10             	add    $0x10,%esp
801001ca:	85 c0                	test   %eax,%eax
801001cc:	74 0f                	je     801001dd <bwrite+0x2d>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001ce:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001d1:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001d4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001d7:	c9                   	leave  
  iderw(b);
801001d8:	e9 c3 22 00 00       	jmp    801024a0 <iderw>
    panic("bwrite");
801001dd:	83 ec 0c             	sub    $0xc,%esp
801001e0:	68 9f 73 10 80       	push   $0x8010739f
801001e5:	e8 a6 01 00 00       	call   80100390 <panic>
801001ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801001f0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001f0:	f3 0f 1e fb          	endbr32 
801001f4:	55                   	push   %ebp
801001f5:	89 e5                	mov    %esp,%ebp
801001f7:	56                   	push   %esi
801001f8:	53                   	push   %ebx
801001f9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001fc:	8d 73 0c             	lea    0xc(%ebx),%esi
801001ff:	83 ec 0c             	sub    $0xc,%esp
80100202:	56                   	push   %esi
80100203:	e8 a8 43 00 00       	call   801045b0 <holdingsleep>
80100208:	83 c4 10             	add    $0x10,%esp
8010020b:	85 c0                	test   %eax,%eax
8010020d:	74 66                	je     80100275 <brelse+0x85>
    panic("brelse");

  releasesleep(&b->lock);
8010020f:	83 ec 0c             	sub    $0xc,%esp
80100212:	56                   	push   %esi
80100213:	e8 58 43 00 00       	call   80104570 <releasesleep>

  acquire(&bcache.lock);
80100218:	c7 04 24 e0 b5 10 80 	movl   $0x8010b5e0,(%esp)
8010021f:	e8 6c 45 00 00       	call   80104790 <acquire>
  b->refcnt--;
80100224:	8b 43 4c             	mov    0x4c(%ebx),%eax
  if (b->refcnt == 0) {
80100227:	83 c4 10             	add    $0x10,%esp
  b->refcnt--;
8010022a:	83 e8 01             	sub    $0x1,%eax
8010022d:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
80100230:	85 c0                	test   %eax,%eax
80100232:	75 2f                	jne    80100263 <brelse+0x73>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100234:	8b 43 54             	mov    0x54(%ebx),%eax
80100237:	8b 53 50             	mov    0x50(%ebx),%edx
8010023a:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
8010023d:	8b 43 50             	mov    0x50(%ebx),%eax
80100240:	8b 53 54             	mov    0x54(%ebx),%edx
80100243:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100246:	a1 30 fd 10 80       	mov    0x8010fd30,%eax
    b->prev = &bcache.head;
8010024b:	c7 43 50 dc fc 10 80 	movl   $0x8010fcdc,0x50(%ebx)
    b->next = bcache.head.next;
80100252:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
80100255:	a1 30 fd 10 80       	mov    0x8010fd30,%eax
8010025a:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
8010025d:	89 1d 30 fd 10 80    	mov    %ebx,0x8010fd30
  }
  
  release(&bcache.lock);
80100263:	c7 45 08 e0 b5 10 80 	movl   $0x8010b5e0,0x8(%ebp)
}
8010026a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010026d:	5b                   	pop    %ebx
8010026e:	5e                   	pop    %esi
8010026f:	5d                   	pop    %ebp
  release(&bcache.lock);
80100270:	e9 db 45 00 00       	jmp    80104850 <release>
    panic("brelse");
80100275:	83 ec 0c             	sub    $0xc,%esp
80100278:	68 a6 73 10 80       	push   $0x801073a6
8010027d:	e8 0e 01 00 00       	call   80100390 <panic>
80100282:	66 90                	xchg   %ax,%ax
80100284:	66 90                	xchg   %ax,%ax
80100286:	66 90                	xchg   %ax,%ax
80100288:	66 90                	xchg   %ax,%ax
8010028a:	66 90                	xchg   %ax,%ax
8010028c:	66 90                	xchg   %ax,%ax
8010028e:	66 90                	xchg   %ax,%ax

80100290 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100290:	f3 0f 1e fb          	endbr32 
80100294:	55                   	push   %ebp
80100295:	89 e5                	mov    %esp,%ebp
80100297:	57                   	push   %edi
80100298:	56                   	push   %esi
80100299:	53                   	push   %ebx
8010029a:	83 ec 18             	sub    $0x18,%esp
  uint target;
  int c;

  iunlock(ip);
8010029d:	ff 75 08             	pushl  0x8(%ebp)
{
801002a0:	8b 5d 10             	mov    0x10(%ebp),%ebx
  target = n;
801002a3:	89 de                	mov    %ebx,%esi
  iunlock(ip);
801002a5:	e8 b6 17 00 00       	call   80101a60 <iunlock>
  acquire(&cons.lock);
801002aa:	c7 04 24 40 a5 10 80 	movl   $0x8010a540,(%esp)
801002b1:	e8 da 44 00 00       	call   80104790 <acquire>
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
    }
    *dst++ = c;
801002b6:	8b 7d 0c             	mov    0xc(%ebp),%edi
  while(n > 0){
801002b9:	83 c4 10             	add    $0x10,%esp
    *dst++ = c;
801002bc:	01 df                	add    %ebx,%edi
  while(n > 0){
801002be:	85 db                	test   %ebx,%ebx
801002c0:	0f 8e 97 00 00 00    	jle    8010035d <consoleread+0xcd>
    while(input.r == input.w){
801002c6:	a1 c0 ff 10 80       	mov    0x8010ffc0,%eax
801002cb:	3b 05 c4 ff 10 80    	cmp    0x8010ffc4,%eax
801002d1:	74 27                	je     801002fa <consoleread+0x6a>
801002d3:	eb 5b                	jmp    80100330 <consoleread+0xa0>
801002d5:	8d 76 00             	lea    0x0(%esi),%esi
      sleep(&input.r, &cons.lock);
801002d8:	83 ec 08             	sub    $0x8,%esp
801002db:	68 40 a5 10 80       	push   $0x8010a540
801002e0:	68 c0 ff 10 80       	push   $0x8010ffc0
801002e5:	e8 66 3e 00 00       	call   80104150 <sleep>
    while(input.r == input.w){
801002ea:	a1 c0 ff 10 80       	mov    0x8010ffc0,%eax
801002ef:	83 c4 10             	add    $0x10,%esp
801002f2:	3b 05 c4 ff 10 80    	cmp    0x8010ffc4,%eax
801002f8:	75 36                	jne    80100330 <consoleread+0xa0>
      if(myproc()->killed){
801002fa:	e8 91 38 00 00       	call   80103b90 <myproc>
801002ff:	8b 48 24             	mov    0x24(%eax),%ecx
80100302:	85 c9                	test   %ecx,%ecx
80100304:	74 d2                	je     801002d8 <consoleread+0x48>
        release(&cons.lock);
80100306:	83 ec 0c             	sub    $0xc,%esp
80100309:	68 40 a5 10 80       	push   $0x8010a540
8010030e:	e8 3d 45 00 00       	call   80104850 <release>
        ilock(ip);
80100313:	5a                   	pop    %edx
80100314:	ff 75 08             	pushl  0x8(%ebp)
80100317:	e8 64 16 00 00       	call   80101980 <ilock>
        return -1;
8010031c:	83 c4 10             	add    $0x10,%esp
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
8010031f:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return -1;
80100322:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100327:	5b                   	pop    %ebx
80100328:	5e                   	pop    %esi
80100329:	5f                   	pop    %edi
8010032a:	5d                   	pop    %ebp
8010032b:	c3                   	ret    
8010032c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = input.buf[input.r++ % INPUT_BUF];
80100330:	8d 50 01             	lea    0x1(%eax),%edx
80100333:	89 15 c0 ff 10 80    	mov    %edx,0x8010ffc0
80100339:	89 c2                	mov    %eax,%edx
8010033b:	83 e2 7f             	and    $0x7f,%edx
8010033e:	0f be 8a 40 ff 10 80 	movsbl -0x7fef00c0(%edx),%ecx
    if(c == C('D')){  // EOF
80100345:	80 f9 04             	cmp    $0x4,%cl
80100348:	74 38                	je     80100382 <consoleread+0xf2>
    *dst++ = c;
8010034a:	89 d8                	mov    %ebx,%eax
    --n;
8010034c:	83 eb 01             	sub    $0x1,%ebx
    *dst++ = c;
8010034f:	f7 d8                	neg    %eax
80100351:	88 0c 07             	mov    %cl,(%edi,%eax,1)
    if(c == '\n')
80100354:	83 f9 0a             	cmp    $0xa,%ecx
80100357:	0f 85 61 ff ff ff    	jne    801002be <consoleread+0x2e>
  release(&cons.lock);
8010035d:	83 ec 0c             	sub    $0xc,%esp
80100360:	68 40 a5 10 80       	push   $0x8010a540
80100365:	e8 e6 44 00 00       	call   80104850 <release>
  ilock(ip);
8010036a:	58                   	pop    %eax
8010036b:	ff 75 08             	pushl  0x8(%ebp)
8010036e:	e8 0d 16 00 00       	call   80101980 <ilock>
  return target - n;
80100373:	89 f0                	mov    %esi,%eax
80100375:	83 c4 10             	add    $0x10,%esp
}
80100378:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return target - n;
8010037b:	29 d8                	sub    %ebx,%eax
}
8010037d:	5b                   	pop    %ebx
8010037e:	5e                   	pop    %esi
8010037f:	5f                   	pop    %edi
80100380:	5d                   	pop    %ebp
80100381:	c3                   	ret    
      if(n < target){
80100382:	39 f3                	cmp    %esi,%ebx
80100384:	73 d7                	jae    8010035d <consoleread+0xcd>
        input.r--;
80100386:	a3 c0 ff 10 80       	mov    %eax,0x8010ffc0
8010038b:	eb d0                	jmp    8010035d <consoleread+0xcd>
8010038d:	8d 76 00             	lea    0x0(%esi),%esi

80100390 <panic>:
{
80100390:	f3 0f 1e fb          	endbr32 
80100394:	55                   	push   %ebp
80100395:	89 e5                	mov    %esp,%ebp
80100397:	56                   	push   %esi
80100398:	53                   	push   %ebx
80100399:	83 ec 30             	sub    $0x30,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
8010039c:	fa                   	cli    
  cons.locking = 0;
8010039d:	c7 05 74 a5 10 80 00 	movl   $0x0,0x8010a574
801003a4:	00 00 00 
  getcallerpcs(&s, pcs);
801003a7:	8d 5d d0             	lea    -0x30(%ebp),%ebx
801003aa:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
801003ad:	e8 0e 27 00 00       	call   80102ac0 <lapicid>
801003b2:	83 ec 08             	sub    $0x8,%esp
801003b5:	50                   	push   %eax
801003b6:	68 ad 73 10 80       	push   $0x801073ad
801003bb:	e8 60 03 00 00       	call   80100720 <cprintf>
  cprintf(s);
801003c0:	58                   	pop    %eax
801003c1:	ff 75 08             	pushl  0x8(%ebp)
801003c4:	e8 57 03 00 00       	call   80100720 <cprintf>
  cprintf("\n");
801003c9:	c7 04 24 df 7c 10 80 	movl   $0x80107cdf,(%esp)
801003d0:	e8 4b 03 00 00       	call   80100720 <cprintf>
  getcallerpcs(&s, pcs);
801003d5:	8d 45 08             	lea    0x8(%ebp),%eax
801003d8:	5a                   	pop    %edx
801003d9:	59                   	pop    %ecx
801003da:	53                   	push   %ebx
801003db:	50                   	push   %eax
801003dc:	e8 4f 42 00 00       	call   80104630 <getcallerpcs>
  for(i=0; i<10; i++)
801003e1:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003e4:	83 ec 08             	sub    $0x8,%esp
801003e7:	ff 33                	pushl  (%ebx)
801003e9:	83 c3 04             	add    $0x4,%ebx
801003ec:	68 c1 73 10 80       	push   $0x801073c1
801003f1:	e8 2a 03 00 00       	call   80100720 <cprintf>
  for(i=0; i<10; i++)
801003f6:	83 c4 10             	add    $0x10,%esp
801003f9:	39 f3                	cmp    %esi,%ebx
801003fb:	75 e7                	jne    801003e4 <panic+0x54>
  panicked = 1; // freeze other CPU
801003fd:	c7 05 78 a5 10 80 01 	movl   $0x1,0x8010a578
80100404:	00 00 00 
  for(;;)
80100407:	eb fe                	jmp    80100407 <panic+0x77>
80100409:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100410 <consputc.part.0>:
consputc(int c)
80100410:	55                   	push   %ebp
80100411:	89 e5                	mov    %esp,%ebp
80100413:	57                   	push   %edi
80100414:	56                   	push   %esi
80100415:	53                   	push   %ebx
80100416:	89 c3                	mov    %eax,%ebx
80100418:	83 ec 1c             	sub    $0x1c,%esp
  if(c == BACKSPACE){
8010041b:	3d 00 01 00 00       	cmp    $0x100,%eax
80100420:	0f 84 5a 01 00 00    	je     80100580 <consputc.part.0+0x170>
    uartputc(c);
80100426:	83 ec 0c             	sub    $0xc,%esp
80100429:	50                   	push   %eax
8010042a:	e8 41 5b 00 00       	call   80105f70 <uartputc>
8010042f:	83 c4 10             	add    $0x10,%esp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100432:	bf d4 03 00 00       	mov    $0x3d4,%edi
80100437:	b8 0e 00 00 00       	mov    $0xe,%eax
8010043c:	89 fa                	mov    %edi,%edx
8010043e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010043f:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
80100444:	89 ca                	mov    %ecx,%edx
80100446:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100447:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010044a:	89 fa                	mov    %edi,%edx
8010044c:	c1 e0 08             	shl    $0x8,%eax
8010044f:	89 c6                	mov    %eax,%esi
80100451:	b8 0f 00 00 00       	mov    $0xf,%eax
80100456:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100457:	89 ca                	mov    %ecx,%edx
80100459:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
8010045a:	0f b6 c0             	movzbl %al,%eax
8010045d:	09 f0                	or     %esi,%eax
  if(c == '\n')
8010045f:	83 fb 0a             	cmp    $0xa,%ebx
80100462:	0f 84 00 01 00 00    	je     80100568 <consputc.part.0+0x158>
  else if(c == BACKSPACE){
80100468:	8b 0d 20 a5 10 80    	mov    0x8010a520,%ecx
8010046e:	81 fb 00 01 00 00    	cmp    $0x100,%ebx
80100474:	0f 84 9e 00 00 00    	je     80100518 <consputc.part.0+0x108>
8010047a:	01 c1                	add    %eax,%ecx
    for (int i = pos + back_counter; i > pos ; i--)
8010047c:	39 c8                	cmp    %ecx,%eax
8010047e:	7d 1e                	jge    8010049e <consputc.part.0+0x8e>
80100480:	8d 94 09 fe 7f 0b 80 	lea    -0x7ff48002(%ecx,%ecx,1),%edx
80100487:	8d b4 00 fe 7f 0b 80 	lea    -0x7ff48002(%eax,%eax,1),%esi
8010048e:	66 90                	xchg   %ax,%ax
      crt[i] = crt[i - 1];
80100490:	0f b7 0a             	movzwl (%edx),%ecx
80100493:	83 ea 02             	sub    $0x2,%edx
80100496:	66 89 4a 04          	mov    %cx,0x4(%edx)
    for (int i = pos + back_counter; i > pos ; i--)
8010049a:	39 d6                	cmp    %edx,%esi
8010049c:	75 f2                	jne    80100490 <consputc.part.0+0x80>
    crt[pos] = (c&0xff) | 0x0700;  // black on white
8010049e:	0f b6 db             	movzbl %bl,%ebx
801004a1:	80 cf 07             	or     $0x7,%bh
801004a4:	66 89 9c 00 00 80 0b 	mov    %bx,-0x7ff48000(%eax,%eax,1)
801004ab:	80 
    pos++;
801004ac:	8d 58 01             	lea    0x1(%eax),%ebx
  if(pos < 0 || pos > 25*80)
801004af:	81 fb d0 07 00 00    	cmp    $0x7d0,%ebx
801004b5:	0f 8f 40 01 00 00    	jg     801005fb <consputc.part.0+0x1eb>
  if((pos/80) >= 24){  // Scroll up.
801004bb:	81 fb 7f 07 00 00    	cmp    $0x77f,%ebx
801004c1:	0f 8f e9 00 00 00    	jg     801005b0 <consputc.part.0+0x1a0>
801004c7:	0f b6 c7             	movzbl %bh,%eax
801004ca:	88 5d e3             	mov    %bl,-0x1d(%ebp)
801004cd:	8b 0d 20 a5 10 80    	mov    0x8010a520,%ecx
801004d3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801004d6:	bf d4 03 00 00       	mov    $0x3d4,%edi
801004db:	b8 0e 00 00 00       	mov    $0xe,%eax
801004e0:	89 fa                	mov    %edi,%edx
801004e2:	ee                   	out    %al,(%dx)
801004e3:	be d5 03 00 00       	mov    $0x3d5,%esi
801004e8:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
801004ec:	89 f2                	mov    %esi,%edx
801004ee:	ee                   	out    %al,(%dx)
801004ef:	b8 0f 00 00 00       	mov    $0xf,%eax
801004f4:	89 fa                	mov    %edi,%edx
801004f6:	ee                   	out    %al,(%dx)
801004f7:	0f b6 45 e3          	movzbl -0x1d(%ebp),%eax
801004fb:	89 f2                	mov    %esi,%edx
801004fd:	ee                   	out    %al,(%dx)
  crt[pos + back_counter] = ' ' | 0x0700;
801004fe:	b8 20 07 00 00       	mov    $0x720,%eax
80100503:	01 cb                	add    %ecx,%ebx
80100505:	66 89 84 1b 00 80 0b 	mov    %ax,-0x7ff48000(%ebx,%ebx,1)
8010050c:	80 
}
8010050d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100510:	5b                   	pop    %ebx
80100511:	5e                   	pop    %esi
80100512:	5f                   	pop    %edi
80100513:	5d                   	pop    %ebp
80100514:	c3                   	ret    
80100515:	8d 76 00             	lea    0x0(%esi),%esi
    for (int i = pos - 1 ; i < pos + back_counter ; i++)
80100518:	8d 58 ff             	lea    -0x1(%eax),%ebx
8010051b:	8d 94 00 00 80 0b 80 	lea    -0x7ff48000(%eax,%eax,1),%edx
80100522:	89 de                	mov    %ebx,%esi
80100524:	85 c9                	test   %ecx,%ecx
80100526:	78 22                	js     8010054a <consputc.part.0+0x13a>
80100528:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010052f:	90                   	nop
      crt[i] = crt[i + 1];
80100530:	0f b7 0a             	movzwl (%edx),%ecx
    for (int i = pos - 1 ; i < pos + back_counter ; i++)
80100533:	83 c6 01             	add    $0x1,%esi
80100536:	83 c2 02             	add    $0x2,%edx
      crt[i] = crt[i + 1];
80100539:	66 89 4a fc          	mov    %cx,-0x4(%edx)
    for (int i = pos - 1 ; i < pos + back_counter ; i++)
8010053d:	8b 0d 20 a5 10 80    	mov    0x8010a520,%ecx
80100543:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
80100546:	39 fe                	cmp    %edi,%esi
80100548:	7c e6                	jl     80100530 <consputc.part.0+0x120>
    if(pos > 0) --pos;
8010054a:	85 c0                	test   %eax,%eax
8010054c:	0f 85 5d ff ff ff    	jne    801004af <consputc.part.0+0x9f>
80100552:	c6 45 e3 00          	movb   $0x0,-0x1d(%ebp)
80100556:	31 db                	xor    %ebx,%ebx
80100558:	c6 45 e4 00          	movb   $0x0,-0x1c(%ebp)
8010055c:	e9 75 ff ff ff       	jmp    801004d6 <consputc.part.0+0xc6>
80100561:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    pos += 80 - pos%80;
80100568:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
8010056d:	f7 e2                	mul    %edx
8010056f:	c1 ea 06             	shr    $0x6,%edx
80100572:	8d 04 92             	lea    (%edx,%edx,4),%eax
80100575:	c1 e0 04             	shl    $0x4,%eax
80100578:	8d 58 50             	lea    0x50(%eax),%ebx
8010057b:	e9 2f ff ff ff       	jmp    801004af <consputc.part.0+0x9f>
    uartputc('\b'); uartputc(' '); uartputc('\b');
80100580:	83 ec 0c             	sub    $0xc,%esp
80100583:	6a 08                	push   $0x8
80100585:	e8 e6 59 00 00       	call   80105f70 <uartputc>
8010058a:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100591:	e8 da 59 00 00       	call   80105f70 <uartputc>
80100596:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010059d:	e8 ce 59 00 00       	call   80105f70 <uartputc>
801005a2:	83 c4 10             	add    $0x10,%esp
801005a5:	e9 88 fe ff ff       	jmp    80100432 <consputc.part.0+0x22>
801005aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801005b0:	83 ec 04             	sub    $0x4,%esp
    pos -= 80;
801005b3:	83 eb 50             	sub    $0x50,%ebx
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801005b6:	68 60 0e 00 00       	push   $0xe60
801005bb:	68 a0 80 0b 80       	push   $0x800b80a0
801005c0:	68 00 80 0b 80       	push   $0x800b8000
801005c5:	e8 76 43 00 00       	call   80104940 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
801005ca:	b8 80 07 00 00       	mov    $0x780,%eax
801005cf:	83 c4 0c             	add    $0xc,%esp
801005d2:	29 d8                	sub    %ebx,%eax
801005d4:	01 c0                	add    %eax,%eax
801005d6:	50                   	push   %eax
801005d7:	8d 84 1b 00 80 0b 80 	lea    -0x7ff48000(%ebx,%ebx,1),%eax
801005de:	6a 00                	push   $0x0
801005e0:	50                   	push   %eax
801005e1:	e8 ba 42 00 00       	call   801048a0 <memset>
801005e6:	88 5d e3             	mov    %bl,-0x1d(%ebp)
801005e9:	8b 0d 20 a5 10 80    	mov    0x8010a520,%ecx
801005ef:	83 c4 10             	add    $0x10,%esp
801005f2:	c6 45 e4 07          	movb   $0x7,-0x1c(%ebp)
801005f6:	e9 db fe ff ff       	jmp    801004d6 <consputc.part.0+0xc6>
    panic("pos under/overflow");
801005fb:	83 ec 0c             	sub    $0xc,%esp
801005fe:	68 c5 73 10 80       	push   $0x801073c5
80100603:	e8 88 fd ff ff       	call   80100390 <panic>
80100608:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010060f:	90                   	nop

80100610 <printint>:
{
80100610:	55                   	push   %ebp
80100611:	89 e5                	mov    %esp,%ebp
80100613:	57                   	push   %edi
80100614:	56                   	push   %esi
80100615:	53                   	push   %ebx
80100616:	83 ec 2c             	sub    $0x2c,%esp
80100619:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  if(sign && (sign = xx < 0))
8010061c:	85 c9                	test   %ecx,%ecx
8010061e:	74 04                	je     80100624 <printint+0x14>
80100620:	85 c0                	test   %eax,%eax
80100622:	78 6d                	js     80100691 <printint+0x81>
    x = xx;
80100624:	89 c1                	mov    %eax,%ecx
80100626:	31 f6                	xor    %esi,%esi
  i = 0;
80100628:	89 75 cc             	mov    %esi,-0x34(%ebp)
8010062b:	31 db                	xor    %ebx,%ebx
8010062d:	8d 7d d7             	lea    -0x29(%ebp),%edi
    buf[i++] = digits[x % base];
80100630:	89 c8                	mov    %ecx,%eax
80100632:	31 d2                	xor    %edx,%edx
80100634:	89 ce                	mov    %ecx,%esi
80100636:	f7 75 d4             	divl   -0x2c(%ebp)
80100639:	0f b6 92 f0 73 10 80 	movzbl -0x7fef8c10(%edx),%edx
80100640:	89 45 d0             	mov    %eax,-0x30(%ebp)
80100643:	89 d8                	mov    %ebx,%eax
80100645:	8d 5b 01             	lea    0x1(%ebx),%ebx
  }while((x /= base) != 0);
80100648:	8b 4d d0             	mov    -0x30(%ebp),%ecx
8010064b:	89 75 d0             	mov    %esi,-0x30(%ebp)
    buf[i++] = digits[x % base];
8010064e:	88 14 1f             	mov    %dl,(%edi,%ebx,1)
  }while((x /= base) != 0);
80100651:	8b 75 d4             	mov    -0x2c(%ebp),%esi
80100654:	39 75 d0             	cmp    %esi,-0x30(%ebp)
80100657:	73 d7                	jae    80100630 <printint+0x20>
80100659:	8b 75 cc             	mov    -0x34(%ebp),%esi
  if(sign)
8010065c:	85 f6                	test   %esi,%esi
8010065e:	74 0c                	je     8010066c <printint+0x5c>
    buf[i++] = '-';
80100660:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
80100665:	89 d8                	mov    %ebx,%eax
    buf[i++] = '-';
80100667:	ba 2d 00 00 00       	mov    $0x2d,%edx
  while(--i >= 0)
8010066c:	8d 5c 05 d7          	lea    -0x29(%ebp,%eax,1),%ebx
80100670:	0f be c2             	movsbl %dl,%eax
  if(panicked){
80100673:	8b 15 78 a5 10 80    	mov    0x8010a578,%edx
80100679:	85 d2                	test   %edx,%edx
8010067b:	74 03                	je     80100680 <printint+0x70>
  asm volatile("cli");
8010067d:	fa                   	cli    
    for(;;)
8010067e:	eb fe                	jmp    8010067e <printint+0x6e>
80100680:	e8 8b fd ff ff       	call   80100410 <consputc.part.0>
  while(--i >= 0)
80100685:	39 fb                	cmp    %edi,%ebx
80100687:	74 10                	je     80100699 <printint+0x89>
80100689:	0f be 03             	movsbl (%ebx),%eax
8010068c:	83 eb 01             	sub    $0x1,%ebx
8010068f:	eb e2                	jmp    80100673 <printint+0x63>
    x = -xx;
80100691:	f7 d8                	neg    %eax
80100693:	89 ce                	mov    %ecx,%esi
80100695:	89 c1                	mov    %eax,%ecx
80100697:	eb 8f                	jmp    80100628 <printint+0x18>
}
80100699:	83 c4 2c             	add    $0x2c,%esp
8010069c:	5b                   	pop    %ebx
8010069d:	5e                   	pop    %esi
8010069e:	5f                   	pop    %edi
8010069f:	5d                   	pop    %ebp
801006a0:	c3                   	ret    
801006a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801006a8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801006af:	90                   	nop

801006b0 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
801006b0:	f3 0f 1e fb          	endbr32 
801006b4:	55                   	push   %ebp
801006b5:	89 e5                	mov    %esp,%ebp
801006b7:	57                   	push   %edi
801006b8:	56                   	push   %esi
801006b9:	53                   	push   %ebx
801006ba:	83 ec 18             	sub    $0x18,%esp
  int i;

  iunlock(ip);
801006bd:	ff 75 08             	pushl  0x8(%ebp)
{
801006c0:	8b 5d 10             	mov    0x10(%ebp),%ebx
  iunlock(ip);
801006c3:	e8 98 13 00 00       	call   80101a60 <iunlock>
  acquire(&cons.lock);
801006c8:	c7 04 24 40 a5 10 80 	movl   $0x8010a540,(%esp)
801006cf:	e8 bc 40 00 00       	call   80104790 <acquire>
  for(i = 0; i < n; i++)
801006d4:	83 c4 10             	add    $0x10,%esp
801006d7:	85 db                	test   %ebx,%ebx
801006d9:	7e 24                	jle    801006ff <consolewrite+0x4f>
801006db:	8b 7d 0c             	mov    0xc(%ebp),%edi
801006de:	8d 34 1f             	lea    (%edi,%ebx,1),%esi
  if(panicked){
801006e1:	8b 15 78 a5 10 80    	mov    0x8010a578,%edx
801006e7:	85 d2                	test   %edx,%edx
801006e9:	74 05                	je     801006f0 <consolewrite+0x40>
801006eb:	fa                   	cli    
    for(;;)
801006ec:	eb fe                	jmp    801006ec <consolewrite+0x3c>
801006ee:	66 90                	xchg   %ax,%ax
    consputc(buf[i] & 0xff);
801006f0:	0f b6 07             	movzbl (%edi),%eax
801006f3:	83 c7 01             	add    $0x1,%edi
801006f6:	e8 15 fd ff ff       	call   80100410 <consputc.part.0>
  for(i = 0; i < n; i++)
801006fb:	39 fe                	cmp    %edi,%esi
801006fd:	75 e2                	jne    801006e1 <consolewrite+0x31>
  release(&cons.lock);
801006ff:	83 ec 0c             	sub    $0xc,%esp
80100702:	68 40 a5 10 80       	push   $0x8010a540
80100707:	e8 44 41 00 00       	call   80104850 <release>
  ilock(ip);
8010070c:	58                   	pop    %eax
8010070d:	ff 75 08             	pushl  0x8(%ebp)
80100710:	e8 6b 12 00 00       	call   80101980 <ilock>

  return n;
}
80100715:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100718:	89 d8                	mov    %ebx,%eax
8010071a:	5b                   	pop    %ebx
8010071b:	5e                   	pop    %esi
8010071c:	5f                   	pop    %edi
8010071d:	5d                   	pop    %ebp
8010071e:	c3                   	ret    
8010071f:	90                   	nop

80100720 <cprintf>:
{
80100720:	f3 0f 1e fb          	endbr32 
80100724:	55                   	push   %ebp
80100725:	89 e5                	mov    %esp,%ebp
80100727:	57                   	push   %edi
80100728:	56                   	push   %esi
80100729:	53                   	push   %ebx
8010072a:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
8010072d:	a1 74 a5 10 80       	mov    0x8010a574,%eax
80100732:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(locking)
80100735:	85 c0                	test   %eax,%eax
80100737:	0f 85 e8 00 00 00    	jne    80100825 <cprintf+0x105>
  if (fmt == 0)
8010073d:	8b 45 08             	mov    0x8(%ebp),%eax
80100740:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100743:	85 c0                	test   %eax,%eax
80100745:	0f 84 5a 01 00 00    	je     801008a5 <cprintf+0x185>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010074b:	0f b6 00             	movzbl (%eax),%eax
8010074e:	85 c0                	test   %eax,%eax
80100750:	74 36                	je     80100788 <cprintf+0x68>
  argp = (uint*)(void*)(&fmt + 1);
80100752:	8d 5d 0c             	lea    0xc(%ebp),%ebx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100755:	31 f6                	xor    %esi,%esi
    if(c != '%'){
80100757:	83 f8 25             	cmp    $0x25,%eax
8010075a:	74 44                	je     801007a0 <cprintf+0x80>
  if(panicked){
8010075c:	8b 0d 78 a5 10 80    	mov    0x8010a578,%ecx
80100762:	85 c9                	test   %ecx,%ecx
80100764:	74 0f                	je     80100775 <cprintf+0x55>
80100766:	fa                   	cli    
    for(;;)
80100767:	eb fe                	jmp    80100767 <cprintf+0x47>
80100769:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100770:	b8 25 00 00 00       	mov    $0x25,%eax
80100775:	e8 96 fc ff ff       	call   80100410 <consputc.part.0>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010077a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010077d:	83 c6 01             	add    $0x1,%esi
80100780:	0f b6 04 30          	movzbl (%eax,%esi,1),%eax
80100784:	85 c0                	test   %eax,%eax
80100786:	75 cf                	jne    80100757 <cprintf+0x37>
  if(locking)
80100788:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010078b:	85 c0                	test   %eax,%eax
8010078d:	0f 85 fd 00 00 00    	jne    80100890 <cprintf+0x170>
}
80100793:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100796:	5b                   	pop    %ebx
80100797:	5e                   	pop    %esi
80100798:	5f                   	pop    %edi
80100799:	5d                   	pop    %ebp
8010079a:	c3                   	ret    
8010079b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010079f:	90                   	nop
    c = fmt[++i] & 0xff;
801007a0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801007a3:	83 c6 01             	add    $0x1,%esi
801007a6:	0f b6 3c 30          	movzbl (%eax,%esi,1),%edi
    if(c == 0)
801007aa:	85 ff                	test   %edi,%edi
801007ac:	74 da                	je     80100788 <cprintf+0x68>
    switch(c){
801007ae:	83 ff 70             	cmp    $0x70,%edi
801007b1:	74 5a                	je     8010080d <cprintf+0xed>
801007b3:	7f 2a                	jg     801007df <cprintf+0xbf>
801007b5:	83 ff 25             	cmp    $0x25,%edi
801007b8:	0f 84 92 00 00 00    	je     80100850 <cprintf+0x130>
801007be:	83 ff 64             	cmp    $0x64,%edi
801007c1:	0f 85 a1 00 00 00    	jne    80100868 <cprintf+0x148>
      printint(*argp++, 10, 1);
801007c7:	8b 03                	mov    (%ebx),%eax
801007c9:	8d 7b 04             	lea    0x4(%ebx),%edi
801007cc:	b9 01 00 00 00       	mov    $0x1,%ecx
801007d1:	ba 0a 00 00 00       	mov    $0xa,%edx
801007d6:	89 fb                	mov    %edi,%ebx
801007d8:	e8 33 fe ff ff       	call   80100610 <printint>
      break;
801007dd:	eb 9b                	jmp    8010077a <cprintf+0x5a>
    switch(c){
801007df:	83 ff 73             	cmp    $0x73,%edi
801007e2:	75 24                	jne    80100808 <cprintf+0xe8>
      if((s = (char*)*argp++) == 0)
801007e4:	8d 7b 04             	lea    0x4(%ebx),%edi
801007e7:	8b 1b                	mov    (%ebx),%ebx
801007e9:	85 db                	test   %ebx,%ebx
801007eb:	75 55                	jne    80100842 <cprintf+0x122>
        s = "(null)";
801007ed:	bb d8 73 10 80       	mov    $0x801073d8,%ebx
      for(; *s; s++)
801007f2:	b8 28 00 00 00       	mov    $0x28,%eax
  if(panicked){
801007f7:	8b 15 78 a5 10 80    	mov    0x8010a578,%edx
801007fd:	85 d2                	test   %edx,%edx
801007ff:	74 39                	je     8010083a <cprintf+0x11a>
80100801:	fa                   	cli    
    for(;;)
80100802:	eb fe                	jmp    80100802 <cprintf+0xe2>
80100804:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    switch(c){
80100808:	83 ff 78             	cmp    $0x78,%edi
8010080b:	75 5b                	jne    80100868 <cprintf+0x148>
      printint(*argp++, 16, 0);
8010080d:	8b 03                	mov    (%ebx),%eax
8010080f:	8d 7b 04             	lea    0x4(%ebx),%edi
80100812:	31 c9                	xor    %ecx,%ecx
80100814:	ba 10 00 00 00       	mov    $0x10,%edx
80100819:	89 fb                	mov    %edi,%ebx
8010081b:	e8 f0 fd ff ff       	call   80100610 <printint>
      break;
80100820:	e9 55 ff ff ff       	jmp    8010077a <cprintf+0x5a>
    acquire(&cons.lock);
80100825:	83 ec 0c             	sub    $0xc,%esp
80100828:	68 40 a5 10 80       	push   $0x8010a540
8010082d:	e8 5e 3f 00 00       	call   80104790 <acquire>
80100832:	83 c4 10             	add    $0x10,%esp
80100835:	e9 03 ff ff ff       	jmp    8010073d <cprintf+0x1d>
8010083a:	e8 d1 fb ff ff       	call   80100410 <consputc.part.0>
      for(; *s; s++)
8010083f:	83 c3 01             	add    $0x1,%ebx
80100842:	0f be 03             	movsbl (%ebx),%eax
80100845:	84 c0                	test   %al,%al
80100847:	75 ae                	jne    801007f7 <cprintf+0xd7>
      if((s = (char*)*argp++) == 0)
80100849:	89 fb                	mov    %edi,%ebx
8010084b:	e9 2a ff ff ff       	jmp    8010077a <cprintf+0x5a>
  if(panicked){
80100850:	8b 3d 78 a5 10 80    	mov    0x8010a578,%edi
80100856:	85 ff                	test   %edi,%edi
80100858:	0f 84 12 ff ff ff    	je     80100770 <cprintf+0x50>
8010085e:	fa                   	cli    
    for(;;)
8010085f:	eb fe                	jmp    8010085f <cprintf+0x13f>
80100861:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(panicked){
80100868:	8b 0d 78 a5 10 80    	mov    0x8010a578,%ecx
8010086e:	85 c9                	test   %ecx,%ecx
80100870:	74 06                	je     80100878 <cprintf+0x158>
80100872:	fa                   	cli    
    for(;;)
80100873:	eb fe                	jmp    80100873 <cprintf+0x153>
80100875:	8d 76 00             	lea    0x0(%esi),%esi
80100878:	b8 25 00 00 00       	mov    $0x25,%eax
8010087d:	e8 8e fb ff ff       	call   80100410 <consputc.part.0>
  if(panicked){
80100882:	8b 15 78 a5 10 80    	mov    0x8010a578,%edx
80100888:	85 d2                	test   %edx,%edx
8010088a:	74 2c                	je     801008b8 <cprintf+0x198>
8010088c:	fa                   	cli    
    for(;;)
8010088d:	eb fe                	jmp    8010088d <cprintf+0x16d>
8010088f:	90                   	nop
    release(&cons.lock);
80100890:	83 ec 0c             	sub    $0xc,%esp
80100893:	68 40 a5 10 80       	push   $0x8010a540
80100898:	e8 b3 3f 00 00       	call   80104850 <release>
8010089d:	83 c4 10             	add    $0x10,%esp
}
801008a0:	e9 ee fe ff ff       	jmp    80100793 <cprintf+0x73>
    panic("null fmt");
801008a5:	83 ec 0c             	sub    $0xc,%esp
801008a8:	68 df 73 10 80       	push   $0x801073df
801008ad:	e8 de fa ff ff       	call   80100390 <panic>
801008b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801008b8:	89 f8                	mov    %edi,%eax
801008ba:	e8 51 fb ff ff       	call   80100410 <consputc.part.0>
801008bf:	e9 b6 fe ff ff       	jmp    8010077a <cprintf+0x5a>
801008c4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801008cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801008cf:	90                   	nop

801008d0 <move_left_cursor>:
void move_left_cursor(){
801008d0:	f3 0f 1e fb          	endbr32 
801008d4:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801008d5:	b8 0e 00 00 00       	mov    $0xe,%eax
801008da:	89 e5                	mov    %esp,%ebp
801008dc:	57                   	push   %edi
801008dd:	bf d4 03 00 00       	mov    $0x3d4,%edi
801008e2:	56                   	push   %esi
801008e3:	89 fa                	mov    %edi,%edx
801008e5:	53                   	push   %ebx
801008e6:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801008e7:	bb d5 03 00 00       	mov    $0x3d5,%ebx
801008ec:	89 da                	mov    %ebx,%edx
801008ee:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
801008ef:	0f b6 c8             	movzbl %al,%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801008f2:	89 fa                	mov    %edi,%edx
801008f4:	b8 0f 00 00 00       	mov    $0xf,%eax
801008f9:	89 ce                	mov    %ecx,%esi
801008fb:	c1 e6 08             	shl    $0x8,%esi
801008fe:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801008ff:	89 da                	mov    %ebx,%edx
80100901:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
80100902:	0f b6 c8             	movzbl %al,%ecx
80100905:	09 f1                	or     %esi,%ecx
  if(crt[pos - 2] != ('$' | 0x0700))
80100907:	66 81 bc 09 fc 7f 0b 	cmpw   $0x724,-0x7ff48004(%ecx,%ecx,1)
8010090e:	80 24 07 
80100911:	74 03                	je     80100916 <move_left_cursor+0x46>
    pos--;
80100913:	83 e9 01             	sub    $0x1,%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100916:	be d4 03 00 00       	mov    $0x3d4,%esi
8010091b:	b8 0e 00 00 00       	mov    $0xe,%eax
80100920:	89 f2                	mov    %esi,%edx
80100922:	ee                   	out    %al,(%dx)
80100923:	bb d5 03 00 00       	mov    $0x3d5,%ebx
  outb(CRTPORT+1, pos>>8);
80100928:	89 c8                	mov    %ecx,%eax
8010092a:	c1 f8 08             	sar    $0x8,%eax
8010092d:	89 da                	mov    %ebx,%edx
8010092f:	ee                   	out    %al,(%dx)
80100930:	b8 0f 00 00 00       	mov    $0xf,%eax
80100935:	89 f2                	mov    %esi,%edx
80100937:	ee                   	out    %al,(%dx)
80100938:	89 c8                	mov    %ecx,%eax
8010093a:	89 da                	mov    %ebx,%edx
8010093c:	ee                   	out    %al,(%dx)
}
8010093d:	5b                   	pop    %ebx
8010093e:	5e                   	pop    %esi
8010093f:	5f                   	pop    %edi
80100940:	5d                   	pop    %ebp
80100941:	c3                   	ret    
80100942:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100949:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100950 <move_right_cursor>:
void move_right_cursor(){
80100950:	f3 0f 1e fb          	endbr32 
80100954:	55                   	push   %ebp
80100955:	89 e5                	mov    %esp,%ebp
80100957:	57                   	push   %edi
80100958:	bf 0e 00 00 00       	mov    $0xe,%edi
8010095d:	56                   	push   %esi
8010095e:	89 f8                	mov    %edi,%eax
80100960:	53                   	push   %ebx
80100961:	bb d4 03 00 00       	mov    $0x3d4,%ebx
80100966:	89 da                	mov    %ebx,%edx
80100968:	83 ec 04             	sub    $0x4,%esp
8010096b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010096c:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
80100971:	89 ca                	mov    %ecx,%edx
80100973:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100974:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100977:	be 0f 00 00 00       	mov    $0xf,%esi
8010097c:	89 da                	mov    %ebx,%edx
8010097e:	c1 e0 08             	shl    $0x8,%eax
80100981:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100984:	89 f0                	mov    %esi,%eax
80100986:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100987:	89 ca                	mov    %ecx,%edx
80100989:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
8010098a:	0f b6 c0             	movzbl %al,%eax
8010098d:	0b 45 f0             	or     -0x10(%ebp),%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100990:	89 da                	mov    %ebx,%edx
  pos++;
80100992:	83 c0 01             	add    $0x1,%eax
80100995:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100998:	89 f8                	mov    %edi,%eax
8010099a:	ee                   	out    %al,(%dx)
  outb(CRTPORT+1, pos>>8);
8010099b:	8b 7d f0             	mov    -0x10(%ebp),%edi
8010099e:	89 ca                	mov    %ecx,%edx
801009a0:	89 f8                	mov    %edi,%eax
801009a2:	c1 f8 08             	sar    $0x8,%eax
801009a5:	ee                   	out    %al,(%dx)
801009a6:	89 f0                	mov    %esi,%eax
801009a8:	89 da                	mov    %ebx,%edx
801009aa:	ee                   	out    %al,(%dx)
801009ab:	89 f8                	mov    %edi,%eax
801009ad:	89 ca                	mov    %ecx,%edx
801009af:	ee                   	out    %al,(%dx)
}
801009b0:	83 c4 04             	add    $0x4,%esp
801009b3:	5b                   	pop    %ebx
801009b4:	5e                   	pop    %esi
801009b5:	5f                   	pop    %edi
801009b6:	5d                   	pop    %ebp
801009b7:	c3                   	ret    
801009b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801009bf:	90                   	nop

801009c0 <consoleintr>:
{
801009c0:	f3 0f 1e fb          	endbr32 
801009c4:	55                   	push   %ebp
801009c5:	89 e5                	mov    %esp,%ebp
801009c7:	57                   	push   %edi
801009c8:	bf d4 03 00 00       	mov    $0x3d4,%edi
801009cd:	56                   	push   %esi
801009ce:	53                   	push   %ebx
801009cf:	83 ec 28             	sub    $0x28,%esp
801009d2:	8b 45 08             	mov    0x8(%ebp),%eax
  acquire(&cons.lock);
801009d5:	68 40 a5 10 80       	push   $0x8010a540
{
801009da:	89 45 e0             	mov    %eax,-0x20(%ebp)
  acquire(&cons.lock);
801009dd:	e8 ae 3d 00 00       	call   80104790 <acquire>
  int c, doprocdump = 0;
801009e2:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  while((c = getc()) >= 0){
801009e9:	83 c4 10             	add    $0x10,%esp
801009ec:	8b 45 e0             	mov    -0x20(%ebp),%eax
801009ef:	ff d0                	call   *%eax
801009f1:	89 c3                	mov    %eax,%ebx
801009f3:	85 c0                	test   %eax,%eax
801009f5:	0f 88 5a 01 00 00    	js     80100b55 <consoleintr+0x195>
    switch(c){
801009fb:	83 fb 7f             	cmp    $0x7f,%ebx
801009fe:	0f 84 88 01 00 00    	je     80100b8c <consoleintr+0x1cc>
80100a04:	0f 8f c6 00 00 00    	jg     80100ad0 <consoleintr+0x110>
80100a0a:	83 fb 10             	cmp    $0x10,%ebx
80100a0d:	0f 84 6d 01 00 00    	je     80100b80 <consoleintr+0x1c0>
80100a13:	83 fb 15             	cmp    $0x15,%ebx
80100a16:	75 38                	jne    80100a50 <consoleintr+0x90>
      while(input.e != input.w &&
80100a18:	a1 c8 ff 10 80       	mov    0x8010ffc8,%eax
80100a1d:	39 05 c4 ff 10 80    	cmp    %eax,0x8010ffc4
80100a23:	74 c7                	je     801009ec <consoleintr+0x2c>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100a25:	83 e8 01             	sub    $0x1,%eax
80100a28:	89 c2                	mov    %eax,%edx
80100a2a:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100a2d:	80 ba 40 ff 10 80 0a 	cmpb   $0xa,-0x7fef00c0(%edx)
80100a34:	74 b6                	je     801009ec <consoleintr+0x2c>
  if(panicked){
80100a36:	8b 0d 78 a5 10 80    	mov    0x8010a578,%ecx
        input.e--;
80100a3c:	a3 c8 ff 10 80       	mov    %eax,0x8010ffc8
  if(panicked){
80100a41:	85 c9                	test   %ecx,%ecx
80100a43:	0f 84 6f 01 00 00    	je     80100bb8 <consoleintr+0x1f8>
  asm volatile("cli");
80100a49:	fa                   	cli    
    for(;;)
80100a4a:	eb fe                	jmp    80100a4a <consoleintr+0x8a>
80100a4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    switch(c){
80100a50:	83 fb 08             	cmp    $0x8,%ebx
80100a53:	0f 84 33 01 00 00    	je     80100b8c <consoleintr+0x1cc>
      if(c != 0 && input.e-input.r < INPUT_BUF){
80100a59:	85 db                	test   %ebx,%ebx
80100a5b:	74 8f                	je     801009ec <consoleintr+0x2c>
80100a5d:	a1 c8 ff 10 80       	mov    0x8010ffc8,%eax
80100a62:	89 c2                	mov    %eax,%edx
80100a64:	2b 15 c0 ff 10 80    	sub    0x8010ffc0,%edx
80100a6a:	83 fa 7f             	cmp    $0x7f,%edx
80100a6d:	0f 87 79 ff ff ff    	ja     801009ec <consoleintr+0x2c>
        c = (c == '\r') ? '\n' : c;
80100a73:	8d 48 01             	lea    0x1(%eax),%ecx
80100a76:	8b 15 78 a5 10 80    	mov    0x8010a578,%edx
80100a7c:	83 e0 7f             	and    $0x7f,%eax
        input.buf[input.e++ % INPUT_BUF] = c;
80100a7f:	89 0d c8 ff 10 80    	mov    %ecx,0x8010ffc8
        c = (c == '\r') ? '\n' : c;
80100a85:	83 fb 0d             	cmp    $0xd,%ebx
80100a88:	0f 84 72 01 00 00    	je     80100c00 <consoleintr+0x240>
        input.buf[input.e++ % INPUT_BUF] = c;
80100a8e:	88 98 40 ff 10 80    	mov    %bl,-0x7fef00c0(%eax)
  if(panicked){
80100a94:	85 d2                	test   %edx,%edx
80100a96:	0f 85 6f 01 00 00    	jne    80100c0b <consoleintr+0x24b>
80100a9c:	89 d8                	mov    %ebx,%eax
80100a9e:	e8 6d f9 ff ff       	call   80100410 <consputc.part.0>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
80100aa3:	83 fb 0a             	cmp    $0xa,%ebx
80100aa6:	0f 84 6e 01 00 00    	je     80100c1a <consoleintr+0x25a>
80100aac:	83 fb 04             	cmp    $0x4,%ebx
80100aaf:	0f 84 65 01 00 00    	je     80100c1a <consoleintr+0x25a>
80100ab5:	a1 c0 ff 10 80       	mov    0x8010ffc0,%eax
80100aba:	83 e8 80             	sub    $0xffffff80,%eax
80100abd:	39 05 c8 ff 10 80    	cmp    %eax,0x8010ffc8
80100ac3:	0f 85 23 ff ff ff    	jne    801009ec <consoleintr+0x2c>
80100ac9:	e9 51 01 00 00       	jmp    80100c1f <consoleintr+0x25f>
80100ace:	66 90                	xchg   %ax,%ax
    switch(c){
80100ad0:	81 fb e4 00 00 00    	cmp    $0xe4,%ebx
80100ad6:	0f 84 04 01 00 00    	je     80100be0 <consoleintr+0x220>
80100adc:	81 fb e5 00 00 00    	cmp    $0xe5,%ebx
80100ae2:	0f 85 75 ff ff ff    	jne    80100a5d <consoleintr+0x9d>
      if(back_counter != 0){
80100ae8:	8b 35 20 a5 10 80    	mov    0x8010a520,%esi
80100aee:	85 f6                	test   %esi,%esi
80100af0:	0f 84 f6 fe ff ff    	je     801009ec <consoleintr+0x2c>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100af6:	b8 0e 00 00 00       	mov    $0xe,%eax
80100afb:	89 fa                	mov    %edi,%edx
80100afd:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100afe:	bb d5 03 00 00       	mov    $0x3d5,%ebx
80100b03:	89 da                	mov    %ebx,%edx
80100b05:	ec                   	in     (%dx),%al
80100b06:	0f b6 c8             	movzbl %al,%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100b09:	89 fa                	mov    %edi,%edx
80100b0b:	b8 0f 00 00 00       	mov    $0xf,%eax
  pos = inb(CRTPORT+1) << 8;
80100b10:	c1 e1 08             	shl    $0x8,%ecx
80100b13:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100b14:	89 da                	mov    %ebx,%edx
80100b16:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
80100b17:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100b1a:	89 fa                	mov    %edi,%edx
80100b1c:	09 c1                	or     %eax,%ecx
80100b1e:	b8 0e 00 00 00       	mov    $0xe,%eax
  pos++;
80100b23:	83 c1 01             	add    $0x1,%ecx
80100b26:	ee                   	out    %al,(%dx)
  outb(CRTPORT+1, pos>>8);
80100b27:	89 ca                	mov    %ecx,%edx
80100b29:	c1 fa 08             	sar    $0x8,%edx
80100b2c:	89 d0                	mov    %edx,%eax
80100b2e:	89 da                	mov    %ebx,%edx
80100b30:	ee                   	out    %al,(%dx)
80100b31:	b8 0f 00 00 00       	mov    $0xf,%eax
80100b36:	89 fa                	mov    %edi,%edx
80100b38:	ee                   	out    %al,(%dx)
80100b39:	89 c8                	mov    %ecx,%eax
80100b3b:	89 da                	mov    %ebx,%edx
80100b3d:	ee                   	out    %al,(%dx)
        back_counter--;
80100b3e:	8d 46 ff             	lea    -0x1(%esi),%eax
80100b41:	a3 20 a5 10 80       	mov    %eax,0x8010a520
  while((c = getc()) >= 0){
80100b46:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100b49:	ff d0                	call   *%eax
80100b4b:	89 c3                	mov    %eax,%ebx
80100b4d:	85 c0                	test   %eax,%eax
80100b4f:	0f 89 a6 fe ff ff    	jns    801009fb <consoleintr+0x3b>
  release(&cons.lock);
80100b55:	83 ec 0c             	sub    $0xc,%esp
80100b58:	68 40 a5 10 80       	push   $0x8010a540
80100b5d:	e8 ee 3c 00 00       	call   80104850 <release>
  if(doprocdump) {
80100b62:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100b65:	83 c4 10             	add    $0x10,%esp
80100b68:	85 c0                	test   %eax,%eax
80100b6a:	0f 85 c9 00 00 00    	jne    80100c39 <consoleintr+0x279>
}
80100b70:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100b73:	5b                   	pop    %ebx
80100b74:	5e                   	pop    %esi
80100b75:	5f                   	pop    %edi
80100b76:	5d                   	pop    %ebp
80100b77:	c3                   	ret    
80100b78:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100b7f:	90                   	nop
    switch(c){
80100b80:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
80100b87:	e9 60 fe ff ff       	jmp    801009ec <consoleintr+0x2c>
      if(input.e != input.w){
80100b8c:	a1 c8 ff 10 80       	mov    0x8010ffc8,%eax
80100b91:	3b 05 c4 ff 10 80    	cmp    0x8010ffc4,%eax
80100b97:	0f 84 4f fe ff ff    	je     801009ec <consoleintr+0x2c>
  if(panicked){
80100b9d:	8b 15 78 a5 10 80    	mov    0x8010a578,%edx
        input.e--;
80100ba3:	83 e8 01             	sub    $0x1,%eax
80100ba6:	a3 c8 ff 10 80       	mov    %eax,0x8010ffc8
  if(panicked){
80100bab:	85 d2                	test   %edx,%edx
80100bad:	74 42                	je     80100bf1 <consoleintr+0x231>
  asm volatile("cli");
80100baf:	fa                   	cli    
    for(;;)
80100bb0:	eb fe                	jmp    80100bb0 <consoleintr+0x1f0>
80100bb2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100bb8:	b8 00 01 00 00       	mov    $0x100,%eax
80100bbd:	e8 4e f8 ff ff       	call   80100410 <consputc.part.0>
      while(input.e != input.w &&
80100bc2:	a1 c8 ff 10 80       	mov    0x8010ffc8,%eax
80100bc7:	3b 05 c4 ff 10 80    	cmp    0x8010ffc4,%eax
80100bcd:	0f 85 52 fe ff ff    	jne    80100a25 <consoleintr+0x65>
80100bd3:	e9 14 fe ff ff       	jmp    801009ec <consoleintr+0x2c>
80100bd8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100bdf:	90                   	nop
      move_left_cursor();
80100be0:	e8 eb fc ff ff       	call   801008d0 <move_left_cursor>
      back_counter++;
80100be5:	83 05 20 a5 10 80 01 	addl   $0x1,0x8010a520
      break;
80100bec:	e9 fb fd ff ff       	jmp    801009ec <consoleintr+0x2c>
80100bf1:	b8 00 01 00 00       	mov    $0x100,%eax
80100bf6:	e8 15 f8 ff ff       	call   80100410 <consputc.part.0>
80100bfb:	e9 ec fd ff ff       	jmp    801009ec <consoleintr+0x2c>
        input.buf[input.e++ % INPUT_BUF] = c;
80100c00:	c6 80 40 ff 10 80 0a 	movb   $0xa,-0x7fef00c0(%eax)
  if(panicked){
80100c07:	85 d2                	test   %edx,%edx
80100c09:	74 05                	je     80100c10 <consoleintr+0x250>
80100c0b:	fa                   	cli    
    for(;;)
80100c0c:	eb fe                	jmp    80100c0c <consoleintr+0x24c>
80100c0e:	66 90                	xchg   %ax,%ax
80100c10:	b8 0a 00 00 00       	mov    $0xa,%eax
80100c15:	e8 f6 f7 ff ff       	call   80100410 <consputc.part.0>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
80100c1a:	a1 c8 ff 10 80       	mov    0x8010ffc8,%eax
          wakeup(&input.r);
80100c1f:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
80100c22:	a3 c4 ff 10 80       	mov    %eax,0x8010ffc4
          wakeup(&input.r);
80100c27:	68 c0 ff 10 80       	push   $0x8010ffc0
80100c2c:	e8 df 36 00 00       	call   80104310 <wakeup>
80100c31:	83 c4 10             	add    $0x10,%esp
80100c34:	e9 b3 fd ff ff       	jmp    801009ec <consoleintr+0x2c>
}
80100c39:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100c3c:	5b                   	pop    %ebx
80100c3d:	5e                   	pop    %esi
80100c3e:	5f                   	pop    %edi
80100c3f:	5d                   	pop    %ebp
    procdump();  // now call procdump() wo. cons.lock held
80100c40:	e9 bb 37 00 00       	jmp    80104400 <procdump>
80100c45:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100c4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100c50 <consoleinit>:

void
consoleinit(void)
{
80100c50:	f3 0f 1e fb          	endbr32 
80100c54:	55                   	push   %ebp
80100c55:	89 e5                	mov    %esp,%ebp
80100c57:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
80100c5a:	68 e8 73 10 80       	push   $0x801073e8
80100c5f:	68 40 a5 10 80       	push   $0x8010a540
80100c64:	e8 a7 39 00 00       	call   80104610 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
80100c69:	58                   	pop    %eax
80100c6a:	5a                   	pop    %edx
80100c6b:	6a 00                	push   $0x0
80100c6d:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
80100c6f:	c7 05 8c 09 11 80 b0 	movl   $0x801006b0,0x8011098c
80100c76:	06 10 80 
  devsw[CONSOLE].read = consoleread;
80100c79:	c7 05 88 09 11 80 90 	movl   $0x80100290,0x80110988
80100c80:	02 10 80 
  cons.locking = 1;
80100c83:	c7 05 74 a5 10 80 01 	movl   $0x1,0x8010a574
80100c8a:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
80100c8d:	e8 be 19 00 00       	call   80102650 <ioapicenable>
}
80100c92:	83 c4 10             	add    $0x10,%esp
80100c95:	c9                   	leave  
80100c96:	c3                   	ret    
80100c97:	66 90                	xchg   %ax,%ax
80100c99:	66 90                	xchg   %ax,%ax
80100c9b:	66 90                	xchg   %ax,%ax
80100c9d:	66 90                	xchg   %ax,%ax
80100c9f:	90                   	nop

80100ca0 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100ca0:	f3 0f 1e fb          	endbr32 
80100ca4:	55                   	push   %ebp
80100ca5:	89 e5                	mov    %esp,%ebp
80100ca7:	57                   	push   %edi
80100ca8:	56                   	push   %esi
80100ca9:	53                   	push   %ebx
80100caa:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100cb0:	e8 db 2e 00 00       	call   80103b90 <myproc>
80100cb5:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)

  begin_op();
80100cbb:	e8 90 22 00 00       	call   80102f50 <begin_op>

  if((ip = namei(path)) == 0){
80100cc0:	83 ec 0c             	sub    $0xc,%esp
80100cc3:	ff 75 08             	pushl  0x8(%ebp)
80100cc6:	e8 85 15 00 00       	call   80102250 <namei>
80100ccb:	83 c4 10             	add    $0x10,%esp
80100cce:	85 c0                	test   %eax,%eax
80100cd0:	0f 84 fe 02 00 00    	je     80100fd4 <exec+0x334>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100cd6:	83 ec 0c             	sub    $0xc,%esp
80100cd9:	89 c3                	mov    %eax,%ebx
80100cdb:	50                   	push   %eax
80100cdc:	e8 9f 0c 00 00       	call   80101980 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100ce1:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100ce7:	6a 34                	push   $0x34
80100ce9:	6a 00                	push   $0x0
80100ceb:	50                   	push   %eax
80100cec:	53                   	push   %ebx
80100ced:	e8 8e 0f 00 00       	call   80101c80 <readi>
80100cf2:	83 c4 20             	add    $0x20,%esp
80100cf5:	83 f8 34             	cmp    $0x34,%eax
80100cf8:	74 26                	je     80100d20 <exec+0x80>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100cfa:	83 ec 0c             	sub    $0xc,%esp
80100cfd:	53                   	push   %ebx
80100cfe:	e8 1d 0f 00 00       	call   80101c20 <iunlockput>
    end_op();
80100d03:	e8 b8 22 00 00       	call   80102fc0 <end_op>
80100d08:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80100d0b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100d10:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100d13:	5b                   	pop    %ebx
80100d14:	5e                   	pop    %esi
80100d15:	5f                   	pop    %edi
80100d16:	5d                   	pop    %ebp
80100d17:	c3                   	ret    
80100d18:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100d1f:	90                   	nop
  if(elf.magic != ELF_MAGIC)
80100d20:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100d27:	45 4c 46 
80100d2a:	75 ce                	jne    80100cfa <exec+0x5a>
  if((pgdir = setupkvm()) == 0)
80100d2c:	e8 af 63 00 00       	call   801070e0 <setupkvm>
80100d31:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80100d37:	85 c0                	test   %eax,%eax
80100d39:	74 bf                	je     80100cfa <exec+0x5a>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100d3b:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100d42:	00 
80100d43:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
80100d49:	0f 84 a4 02 00 00    	je     80100ff3 <exec+0x353>
  sz = 0;
80100d4f:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80100d56:	00 00 00 
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100d59:	31 ff                	xor    %edi,%edi
80100d5b:	e9 86 00 00 00       	jmp    80100de6 <exec+0x146>
    if(ph.type != ELF_PROG_LOAD)
80100d60:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100d67:	75 6c                	jne    80100dd5 <exec+0x135>
    if(ph.memsz < ph.filesz)
80100d69:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100d6f:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100d75:	0f 82 87 00 00 00    	jb     80100e02 <exec+0x162>
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100d7b:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100d81:	72 7f                	jb     80100e02 <exec+0x162>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100d83:	83 ec 04             	sub    $0x4,%esp
80100d86:	50                   	push   %eax
80100d87:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100d8d:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100d93:	e8 68 61 00 00       	call   80106f00 <allocuvm>
80100d98:	83 c4 10             	add    $0x10,%esp
80100d9b:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100da1:	85 c0                	test   %eax,%eax
80100da3:	74 5d                	je     80100e02 <exec+0x162>
    if(ph.vaddr % PGSIZE != 0)
80100da5:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100dab:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100db0:	75 50                	jne    80100e02 <exec+0x162>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100db2:	83 ec 0c             	sub    $0xc,%esp
80100db5:	ff b5 14 ff ff ff    	pushl  -0xec(%ebp)
80100dbb:	ff b5 08 ff ff ff    	pushl  -0xf8(%ebp)
80100dc1:	53                   	push   %ebx
80100dc2:	50                   	push   %eax
80100dc3:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100dc9:	e8 62 60 00 00       	call   80106e30 <loaduvm>
80100dce:	83 c4 20             	add    $0x20,%esp
80100dd1:	85 c0                	test   %eax,%eax
80100dd3:	78 2d                	js     80100e02 <exec+0x162>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100dd5:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100ddc:	83 c7 01             	add    $0x1,%edi
80100ddf:	83 c6 20             	add    $0x20,%esi
80100de2:	39 f8                	cmp    %edi,%eax
80100de4:	7e 3a                	jle    80100e20 <exec+0x180>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100de6:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100dec:	6a 20                	push   $0x20
80100dee:	56                   	push   %esi
80100def:	50                   	push   %eax
80100df0:	53                   	push   %ebx
80100df1:	e8 8a 0e 00 00       	call   80101c80 <readi>
80100df6:	83 c4 10             	add    $0x10,%esp
80100df9:	83 f8 20             	cmp    $0x20,%eax
80100dfc:	0f 84 5e ff ff ff    	je     80100d60 <exec+0xc0>
    freevm(pgdir);
80100e02:	83 ec 0c             	sub    $0xc,%esp
80100e05:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100e0b:	e8 50 62 00 00       	call   80107060 <freevm>
  if(ip){
80100e10:	83 c4 10             	add    $0x10,%esp
80100e13:	e9 e2 fe ff ff       	jmp    80100cfa <exec+0x5a>
80100e18:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100e1f:	90                   	nop
80100e20:	8b bd f0 fe ff ff    	mov    -0x110(%ebp),%edi
80100e26:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
80100e2c:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
80100e32:	8d b7 00 20 00 00    	lea    0x2000(%edi),%esi
  iunlockput(ip);
80100e38:	83 ec 0c             	sub    $0xc,%esp
80100e3b:	53                   	push   %ebx
80100e3c:	e8 df 0d 00 00       	call   80101c20 <iunlockput>
  end_op();
80100e41:	e8 7a 21 00 00       	call   80102fc0 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100e46:	83 c4 0c             	add    $0xc,%esp
80100e49:	56                   	push   %esi
80100e4a:	57                   	push   %edi
80100e4b:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100e51:	57                   	push   %edi
80100e52:	e8 a9 60 00 00       	call   80106f00 <allocuvm>
80100e57:	83 c4 10             	add    $0x10,%esp
80100e5a:	89 c6                	mov    %eax,%esi
80100e5c:	85 c0                	test   %eax,%eax
80100e5e:	0f 84 94 00 00 00    	je     80100ef8 <exec+0x258>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100e64:	83 ec 08             	sub    $0x8,%esp
80100e67:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
  for(argc = 0; argv[argc]; argc++) {
80100e6d:	89 f3                	mov    %esi,%ebx
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100e6f:	50                   	push   %eax
80100e70:	57                   	push   %edi
  for(argc = 0; argv[argc]; argc++) {
80100e71:	31 ff                	xor    %edi,%edi
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100e73:	e8 08 63 00 00       	call   80107180 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100e78:	8b 45 0c             	mov    0xc(%ebp),%eax
80100e7b:	83 c4 10             	add    $0x10,%esp
80100e7e:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80100e84:	8b 00                	mov    (%eax),%eax
80100e86:	85 c0                	test   %eax,%eax
80100e88:	0f 84 8b 00 00 00    	je     80100f19 <exec+0x279>
80100e8e:	89 b5 f0 fe ff ff    	mov    %esi,-0x110(%ebp)
80100e94:	8b b5 f4 fe ff ff    	mov    -0x10c(%ebp),%esi
80100e9a:	eb 23                	jmp    80100ebf <exec+0x21f>
80100e9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100ea0:	8b 45 0c             	mov    0xc(%ebp),%eax
    ustack[3+argc] = sp;
80100ea3:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
  for(argc = 0; argv[argc]; argc++) {
80100eaa:	83 c7 01             	add    $0x1,%edi
    ustack[3+argc] = sp;
80100ead:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
  for(argc = 0; argv[argc]; argc++) {
80100eb3:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80100eb6:	85 c0                	test   %eax,%eax
80100eb8:	74 59                	je     80100f13 <exec+0x273>
    if(argc >= MAXARG)
80100eba:	83 ff 20             	cmp    $0x20,%edi
80100ebd:	74 39                	je     80100ef8 <exec+0x258>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100ebf:	83 ec 0c             	sub    $0xc,%esp
80100ec2:	50                   	push   %eax
80100ec3:	e8 d8 3b 00 00       	call   80104aa0 <strlen>
80100ec8:	f7 d0                	not    %eax
80100eca:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100ecc:	58                   	pop    %eax
80100ecd:	8b 45 0c             	mov    0xc(%ebp),%eax
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100ed0:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100ed3:	ff 34 b8             	pushl  (%eax,%edi,4)
80100ed6:	e8 c5 3b 00 00       	call   80104aa0 <strlen>
80100edb:	83 c0 01             	add    $0x1,%eax
80100ede:	50                   	push   %eax
80100edf:	8b 45 0c             	mov    0xc(%ebp),%eax
80100ee2:	ff 34 b8             	pushl  (%eax,%edi,4)
80100ee5:	53                   	push   %ebx
80100ee6:	56                   	push   %esi
80100ee7:	e8 f4 63 00 00       	call   801072e0 <copyout>
80100eec:	83 c4 20             	add    $0x20,%esp
80100eef:	85 c0                	test   %eax,%eax
80100ef1:	79 ad                	jns    80100ea0 <exec+0x200>
80100ef3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100ef7:	90                   	nop
    freevm(pgdir);
80100ef8:	83 ec 0c             	sub    $0xc,%esp
80100efb:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100f01:	e8 5a 61 00 00       	call   80107060 <freevm>
80100f06:	83 c4 10             	add    $0x10,%esp
  return -1;
80100f09:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100f0e:	e9 fd fd ff ff       	jmp    80100d10 <exec+0x70>
80100f13:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100f19:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
80100f20:	89 d9                	mov    %ebx,%ecx
  ustack[3+argc] = 0;
80100f22:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
80100f29:	00 00 00 00 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100f2d:	29 c1                	sub    %eax,%ecx
  sp -= (3+argc+1) * 4;
80100f2f:	83 c0 0c             	add    $0xc,%eax
  ustack[1] = argc;
80100f32:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  sp -= (3+argc+1) * 4;
80100f38:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100f3a:	50                   	push   %eax
80100f3b:	52                   	push   %edx
80100f3c:	53                   	push   %ebx
80100f3d:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
  ustack[0] = 0xffffffff;  // fake return PC
80100f43:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100f4a:	ff ff ff 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100f4d:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100f53:	e8 88 63 00 00       	call   801072e0 <copyout>
80100f58:	83 c4 10             	add    $0x10,%esp
80100f5b:	85 c0                	test   %eax,%eax
80100f5d:	78 99                	js     80100ef8 <exec+0x258>
  for(last=s=path; *s; s++)
80100f5f:	8b 45 08             	mov    0x8(%ebp),%eax
80100f62:	8b 55 08             	mov    0x8(%ebp),%edx
80100f65:	0f b6 00             	movzbl (%eax),%eax
80100f68:	84 c0                	test   %al,%al
80100f6a:	74 13                	je     80100f7f <exec+0x2df>
80100f6c:	89 d1                	mov    %edx,%ecx
80100f6e:	66 90                	xchg   %ax,%ax
    if(*s == '/')
80100f70:	83 c1 01             	add    $0x1,%ecx
80100f73:	3c 2f                	cmp    $0x2f,%al
  for(last=s=path; *s; s++)
80100f75:	0f b6 01             	movzbl (%ecx),%eax
    if(*s == '/')
80100f78:	0f 44 d1             	cmove  %ecx,%edx
  for(last=s=path; *s; s++)
80100f7b:	84 c0                	test   %al,%al
80100f7d:	75 f1                	jne    80100f70 <exec+0x2d0>
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100f7f:	8b bd ec fe ff ff    	mov    -0x114(%ebp),%edi
80100f85:	83 ec 04             	sub    $0x4,%esp
80100f88:	6a 10                	push   $0x10
80100f8a:	89 f8                	mov    %edi,%eax
80100f8c:	52                   	push   %edx
80100f8d:	83 c0 6c             	add    $0x6c,%eax
80100f90:	50                   	push   %eax
80100f91:	e8 ca 3a 00 00       	call   80104a60 <safestrcpy>
  curproc->pgdir = pgdir;
80100f96:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
  oldpgdir = curproc->pgdir;
80100f9c:	89 f8                	mov    %edi,%eax
80100f9e:	8b 7f 04             	mov    0x4(%edi),%edi
  curproc->sz = sz;
80100fa1:	89 30                	mov    %esi,(%eax)
  curproc->pgdir = pgdir;
80100fa3:	89 48 04             	mov    %ecx,0x4(%eax)
  curproc->tf->eip = elf.entry;  // main
80100fa6:	89 c1                	mov    %eax,%ecx
80100fa8:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100fae:	8b 40 18             	mov    0x18(%eax),%eax
80100fb1:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100fb4:	8b 41 18             	mov    0x18(%ecx),%eax
80100fb7:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
80100fba:	89 0c 24             	mov    %ecx,(%esp)
80100fbd:	e8 de 5c 00 00       	call   80106ca0 <switchuvm>
  freevm(oldpgdir);
80100fc2:	89 3c 24             	mov    %edi,(%esp)
80100fc5:	e8 96 60 00 00       	call   80107060 <freevm>
  return 0;
80100fca:	83 c4 10             	add    $0x10,%esp
80100fcd:	31 c0                	xor    %eax,%eax
80100fcf:	e9 3c fd ff ff       	jmp    80100d10 <exec+0x70>
    end_op();
80100fd4:	e8 e7 1f 00 00       	call   80102fc0 <end_op>
    cprintf("exec: fail\n");
80100fd9:	83 ec 0c             	sub    $0xc,%esp
80100fdc:	68 01 74 10 80       	push   $0x80107401
80100fe1:	e8 3a f7 ff ff       	call   80100720 <cprintf>
    return -1;
80100fe6:	83 c4 10             	add    $0x10,%esp
80100fe9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100fee:	e9 1d fd ff ff       	jmp    80100d10 <exec+0x70>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100ff3:	31 ff                	xor    %edi,%edi
80100ff5:	be 00 20 00 00       	mov    $0x2000,%esi
80100ffa:	e9 39 fe ff ff       	jmp    80100e38 <exec+0x198>
80100fff:	90                   	nop

80101000 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80101000:	f3 0f 1e fb          	endbr32 
80101004:	55                   	push   %ebp
80101005:	89 e5                	mov    %esp,%ebp
80101007:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
8010100a:	68 0d 74 10 80       	push   $0x8010740d
8010100f:	68 e0 ff 10 80       	push   $0x8010ffe0
80101014:	e8 f7 35 00 00       	call   80104610 <initlock>
}
80101019:	83 c4 10             	add    $0x10,%esp
8010101c:	c9                   	leave  
8010101d:	c3                   	ret    
8010101e:	66 90                	xchg   %ax,%ax

80101020 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80101020:	f3 0f 1e fb          	endbr32 
80101024:	55                   	push   %ebp
80101025:	89 e5                	mov    %esp,%ebp
80101027:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80101028:	bb 14 00 11 80       	mov    $0x80110014,%ebx
{
8010102d:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80101030:	68 e0 ff 10 80       	push   $0x8010ffe0
80101035:	e8 56 37 00 00       	call   80104790 <acquire>
8010103a:	83 c4 10             	add    $0x10,%esp
8010103d:	eb 0c                	jmp    8010104b <filealloc+0x2b>
8010103f:	90                   	nop
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80101040:	83 c3 18             	add    $0x18,%ebx
80101043:	81 fb 74 09 11 80    	cmp    $0x80110974,%ebx
80101049:	74 25                	je     80101070 <filealloc+0x50>
    if(f->ref == 0){
8010104b:	8b 43 04             	mov    0x4(%ebx),%eax
8010104e:	85 c0                	test   %eax,%eax
80101050:	75 ee                	jne    80101040 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80101052:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80101055:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
8010105c:	68 e0 ff 10 80       	push   $0x8010ffe0
80101061:	e8 ea 37 00 00       	call   80104850 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80101066:	89 d8                	mov    %ebx,%eax
      return f;
80101068:	83 c4 10             	add    $0x10,%esp
}
8010106b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010106e:	c9                   	leave  
8010106f:	c3                   	ret    
  release(&ftable.lock);
80101070:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80101073:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80101075:	68 e0 ff 10 80       	push   $0x8010ffe0
8010107a:	e8 d1 37 00 00       	call   80104850 <release>
}
8010107f:	89 d8                	mov    %ebx,%eax
  return 0;
80101081:	83 c4 10             	add    $0x10,%esp
}
80101084:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101087:	c9                   	leave  
80101088:	c3                   	ret    
80101089:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101090 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80101090:	f3 0f 1e fb          	endbr32 
80101094:	55                   	push   %ebp
80101095:	89 e5                	mov    %esp,%ebp
80101097:	53                   	push   %ebx
80101098:	83 ec 10             	sub    $0x10,%esp
8010109b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
8010109e:	68 e0 ff 10 80       	push   $0x8010ffe0
801010a3:	e8 e8 36 00 00       	call   80104790 <acquire>
  if(f->ref < 1)
801010a8:	8b 43 04             	mov    0x4(%ebx),%eax
801010ab:	83 c4 10             	add    $0x10,%esp
801010ae:	85 c0                	test   %eax,%eax
801010b0:	7e 1a                	jle    801010cc <filedup+0x3c>
    panic("filedup");
  f->ref++;
801010b2:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
801010b5:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
801010b8:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
801010bb:	68 e0 ff 10 80       	push   $0x8010ffe0
801010c0:	e8 8b 37 00 00       	call   80104850 <release>
  return f;
}
801010c5:	89 d8                	mov    %ebx,%eax
801010c7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801010ca:	c9                   	leave  
801010cb:	c3                   	ret    
    panic("filedup");
801010cc:	83 ec 0c             	sub    $0xc,%esp
801010cf:	68 14 74 10 80       	push   $0x80107414
801010d4:	e8 b7 f2 ff ff       	call   80100390 <panic>
801010d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801010e0 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
801010e0:	f3 0f 1e fb          	endbr32 
801010e4:	55                   	push   %ebp
801010e5:	89 e5                	mov    %esp,%ebp
801010e7:	57                   	push   %edi
801010e8:	56                   	push   %esi
801010e9:	53                   	push   %ebx
801010ea:	83 ec 28             	sub    $0x28,%esp
801010ed:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
801010f0:	68 e0 ff 10 80       	push   $0x8010ffe0
801010f5:	e8 96 36 00 00       	call   80104790 <acquire>
  if(f->ref < 1)
801010fa:	8b 53 04             	mov    0x4(%ebx),%edx
801010fd:	83 c4 10             	add    $0x10,%esp
80101100:	85 d2                	test   %edx,%edx
80101102:	0f 8e a1 00 00 00    	jle    801011a9 <fileclose+0xc9>
    panic("fileclose");
  if(--f->ref > 0){
80101108:	83 ea 01             	sub    $0x1,%edx
8010110b:	89 53 04             	mov    %edx,0x4(%ebx)
8010110e:	75 40                	jne    80101150 <fileclose+0x70>
    release(&ftable.lock);
    return;
  }
  ff = *f;
80101110:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80101114:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80101117:	8b 3b                	mov    (%ebx),%edi
  f->type = FD_NONE;
80101119:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
8010111f:	8b 73 0c             	mov    0xc(%ebx),%esi
80101122:	88 45 e7             	mov    %al,-0x19(%ebp)
80101125:	8b 43 10             	mov    0x10(%ebx),%eax
  release(&ftable.lock);
80101128:	68 e0 ff 10 80       	push   $0x8010ffe0
  ff = *f;
8010112d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80101130:	e8 1b 37 00 00       	call   80104850 <release>

  if(ff.type == FD_PIPE)
80101135:	83 c4 10             	add    $0x10,%esp
80101138:	83 ff 01             	cmp    $0x1,%edi
8010113b:	74 53                	je     80101190 <fileclose+0xb0>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
8010113d:	83 ff 02             	cmp    $0x2,%edi
80101140:	74 26                	je     80101168 <fileclose+0x88>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80101142:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101145:	5b                   	pop    %ebx
80101146:	5e                   	pop    %esi
80101147:	5f                   	pop    %edi
80101148:	5d                   	pop    %ebp
80101149:	c3                   	ret    
8010114a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&ftable.lock);
80101150:	c7 45 08 e0 ff 10 80 	movl   $0x8010ffe0,0x8(%ebp)
}
80101157:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010115a:	5b                   	pop    %ebx
8010115b:	5e                   	pop    %esi
8010115c:	5f                   	pop    %edi
8010115d:	5d                   	pop    %ebp
    release(&ftable.lock);
8010115e:	e9 ed 36 00 00       	jmp    80104850 <release>
80101163:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101167:	90                   	nop
    begin_op();
80101168:	e8 e3 1d 00 00       	call   80102f50 <begin_op>
    iput(ff.ip);
8010116d:	83 ec 0c             	sub    $0xc,%esp
80101170:	ff 75 e0             	pushl  -0x20(%ebp)
80101173:	e8 38 09 00 00       	call   80101ab0 <iput>
    end_op();
80101178:	83 c4 10             	add    $0x10,%esp
}
8010117b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010117e:	5b                   	pop    %ebx
8010117f:	5e                   	pop    %esi
80101180:	5f                   	pop    %edi
80101181:	5d                   	pop    %ebp
    end_op();
80101182:	e9 39 1e 00 00       	jmp    80102fc0 <end_op>
80101187:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010118e:	66 90                	xchg   %ax,%ax
    pipeclose(ff.pipe, ff.writable);
80101190:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80101194:	83 ec 08             	sub    $0x8,%esp
80101197:	53                   	push   %ebx
80101198:	56                   	push   %esi
80101199:	e8 82 25 00 00       	call   80103720 <pipeclose>
8010119e:	83 c4 10             	add    $0x10,%esp
}
801011a1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801011a4:	5b                   	pop    %ebx
801011a5:	5e                   	pop    %esi
801011a6:	5f                   	pop    %edi
801011a7:	5d                   	pop    %ebp
801011a8:	c3                   	ret    
    panic("fileclose");
801011a9:	83 ec 0c             	sub    $0xc,%esp
801011ac:	68 1c 74 10 80       	push   $0x8010741c
801011b1:	e8 da f1 ff ff       	call   80100390 <panic>
801011b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801011bd:	8d 76 00             	lea    0x0(%esi),%esi

801011c0 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
801011c0:	f3 0f 1e fb          	endbr32 
801011c4:	55                   	push   %ebp
801011c5:	89 e5                	mov    %esp,%ebp
801011c7:	53                   	push   %ebx
801011c8:	83 ec 04             	sub    $0x4,%esp
801011cb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
801011ce:	83 3b 02             	cmpl   $0x2,(%ebx)
801011d1:	75 2d                	jne    80101200 <filestat+0x40>
    ilock(f->ip);
801011d3:	83 ec 0c             	sub    $0xc,%esp
801011d6:	ff 73 10             	pushl  0x10(%ebx)
801011d9:	e8 a2 07 00 00       	call   80101980 <ilock>
    stati(f->ip, st);
801011de:	58                   	pop    %eax
801011df:	5a                   	pop    %edx
801011e0:	ff 75 0c             	pushl  0xc(%ebp)
801011e3:	ff 73 10             	pushl  0x10(%ebx)
801011e6:	e8 65 0a 00 00       	call   80101c50 <stati>
    iunlock(f->ip);
801011eb:	59                   	pop    %ecx
801011ec:	ff 73 10             	pushl  0x10(%ebx)
801011ef:	e8 6c 08 00 00       	call   80101a60 <iunlock>
    return 0;
  }
  return -1;
}
801011f4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return 0;
801011f7:	83 c4 10             	add    $0x10,%esp
801011fa:	31 c0                	xor    %eax,%eax
}
801011fc:	c9                   	leave  
801011fd:	c3                   	ret    
801011fe:	66 90                	xchg   %ax,%ax
80101200:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80101203:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80101208:	c9                   	leave  
80101209:	c3                   	ret    
8010120a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101210 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80101210:	f3 0f 1e fb          	endbr32 
80101214:	55                   	push   %ebp
80101215:	89 e5                	mov    %esp,%ebp
80101217:	57                   	push   %edi
80101218:	56                   	push   %esi
80101219:	53                   	push   %ebx
8010121a:	83 ec 0c             	sub    $0xc,%esp
8010121d:	8b 5d 08             	mov    0x8(%ebp),%ebx
80101220:	8b 75 0c             	mov    0xc(%ebp),%esi
80101223:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80101226:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
8010122a:	74 64                	je     80101290 <fileread+0x80>
    return -1;
  if(f->type == FD_PIPE)
8010122c:	8b 03                	mov    (%ebx),%eax
8010122e:	83 f8 01             	cmp    $0x1,%eax
80101231:	74 45                	je     80101278 <fileread+0x68>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
80101233:	83 f8 02             	cmp    $0x2,%eax
80101236:	75 5f                	jne    80101297 <fileread+0x87>
    ilock(f->ip);
80101238:	83 ec 0c             	sub    $0xc,%esp
8010123b:	ff 73 10             	pushl  0x10(%ebx)
8010123e:	e8 3d 07 00 00       	call   80101980 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80101243:	57                   	push   %edi
80101244:	ff 73 14             	pushl  0x14(%ebx)
80101247:	56                   	push   %esi
80101248:	ff 73 10             	pushl  0x10(%ebx)
8010124b:	e8 30 0a 00 00       	call   80101c80 <readi>
80101250:	83 c4 20             	add    $0x20,%esp
80101253:	89 c6                	mov    %eax,%esi
80101255:	85 c0                	test   %eax,%eax
80101257:	7e 03                	jle    8010125c <fileread+0x4c>
      f->off += r;
80101259:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
8010125c:	83 ec 0c             	sub    $0xc,%esp
8010125f:	ff 73 10             	pushl  0x10(%ebx)
80101262:	e8 f9 07 00 00       	call   80101a60 <iunlock>
    return r;
80101267:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
8010126a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010126d:	89 f0                	mov    %esi,%eax
8010126f:	5b                   	pop    %ebx
80101270:	5e                   	pop    %esi
80101271:	5f                   	pop    %edi
80101272:	5d                   	pop    %ebp
80101273:	c3                   	ret    
80101274:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return piperead(f->pipe, addr, n);
80101278:	8b 43 0c             	mov    0xc(%ebx),%eax
8010127b:	89 45 08             	mov    %eax,0x8(%ebp)
}
8010127e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101281:	5b                   	pop    %ebx
80101282:	5e                   	pop    %esi
80101283:	5f                   	pop    %edi
80101284:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
80101285:	e9 36 26 00 00       	jmp    801038c0 <piperead>
8010128a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80101290:	be ff ff ff ff       	mov    $0xffffffff,%esi
80101295:	eb d3                	jmp    8010126a <fileread+0x5a>
  panic("fileread");
80101297:	83 ec 0c             	sub    $0xc,%esp
8010129a:	68 26 74 10 80       	push   $0x80107426
8010129f:	e8 ec f0 ff ff       	call   80100390 <panic>
801012a4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801012ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801012af:	90                   	nop

801012b0 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
801012b0:	f3 0f 1e fb          	endbr32 
801012b4:	55                   	push   %ebp
801012b5:	89 e5                	mov    %esp,%ebp
801012b7:	57                   	push   %edi
801012b8:	56                   	push   %esi
801012b9:	53                   	push   %ebx
801012ba:	83 ec 1c             	sub    $0x1c,%esp
801012bd:	8b 45 0c             	mov    0xc(%ebp),%eax
801012c0:	8b 75 08             	mov    0x8(%ebp),%esi
801012c3:	89 45 dc             	mov    %eax,-0x24(%ebp)
801012c6:	8b 45 10             	mov    0x10(%ebp),%eax
  int r;

  if(f->writable == 0)
801012c9:	80 7e 09 00          	cmpb   $0x0,0x9(%esi)
{
801012cd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
801012d0:	0f 84 c1 00 00 00    	je     80101397 <filewrite+0xe7>
    return -1;
  if(f->type == FD_PIPE)
801012d6:	8b 06                	mov    (%esi),%eax
801012d8:	83 f8 01             	cmp    $0x1,%eax
801012db:	0f 84 c3 00 00 00    	je     801013a4 <filewrite+0xf4>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
801012e1:	83 f8 02             	cmp    $0x2,%eax
801012e4:	0f 85 cc 00 00 00    	jne    801013b6 <filewrite+0x106>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
801012ea:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
801012ed:	31 ff                	xor    %edi,%edi
    while(i < n){
801012ef:	85 c0                	test   %eax,%eax
801012f1:	7f 34                	jg     80101327 <filewrite+0x77>
801012f3:	e9 98 00 00 00       	jmp    80101390 <filewrite+0xe0>
801012f8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801012ff:	90                   	nop
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80101300:	01 46 14             	add    %eax,0x14(%esi)
      iunlock(f->ip);
80101303:	83 ec 0c             	sub    $0xc,%esp
80101306:	ff 76 10             	pushl  0x10(%esi)
        f->off += r;
80101309:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
8010130c:	e8 4f 07 00 00       	call   80101a60 <iunlock>
      end_op();
80101311:	e8 aa 1c 00 00       	call   80102fc0 <end_op>

      if(r < 0)
        break;
      if(r != n1)
80101316:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101319:	83 c4 10             	add    $0x10,%esp
8010131c:	39 c3                	cmp    %eax,%ebx
8010131e:	75 60                	jne    80101380 <filewrite+0xd0>
        panic("short filewrite");
      i += r;
80101320:	01 df                	add    %ebx,%edi
    while(i < n){
80101322:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101325:	7e 69                	jle    80101390 <filewrite+0xe0>
      int n1 = n - i;
80101327:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
8010132a:	b8 00 06 00 00       	mov    $0x600,%eax
8010132f:	29 fb                	sub    %edi,%ebx
      if(n1 > max)
80101331:	81 fb 00 06 00 00    	cmp    $0x600,%ebx
80101337:	0f 4f d8             	cmovg  %eax,%ebx
      begin_op();
8010133a:	e8 11 1c 00 00       	call   80102f50 <begin_op>
      ilock(f->ip);
8010133f:	83 ec 0c             	sub    $0xc,%esp
80101342:	ff 76 10             	pushl  0x10(%esi)
80101345:	e8 36 06 00 00       	call   80101980 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
8010134a:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010134d:	53                   	push   %ebx
8010134e:	ff 76 14             	pushl  0x14(%esi)
80101351:	01 f8                	add    %edi,%eax
80101353:	50                   	push   %eax
80101354:	ff 76 10             	pushl  0x10(%esi)
80101357:	e8 24 0a 00 00       	call   80101d80 <writei>
8010135c:	83 c4 20             	add    $0x20,%esp
8010135f:	85 c0                	test   %eax,%eax
80101361:	7f 9d                	jg     80101300 <filewrite+0x50>
      iunlock(f->ip);
80101363:	83 ec 0c             	sub    $0xc,%esp
80101366:	ff 76 10             	pushl  0x10(%esi)
80101369:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010136c:	e8 ef 06 00 00       	call   80101a60 <iunlock>
      end_op();
80101371:	e8 4a 1c 00 00       	call   80102fc0 <end_op>
      if(r < 0)
80101376:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101379:	83 c4 10             	add    $0x10,%esp
8010137c:	85 c0                	test   %eax,%eax
8010137e:	75 17                	jne    80101397 <filewrite+0xe7>
        panic("short filewrite");
80101380:	83 ec 0c             	sub    $0xc,%esp
80101383:	68 2f 74 10 80       	push   $0x8010742f
80101388:	e8 03 f0 ff ff       	call   80100390 <panic>
8010138d:	8d 76 00             	lea    0x0(%esi),%esi
    }
    return i == n ? n : -1;
80101390:	89 f8                	mov    %edi,%eax
80101392:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
80101395:	74 05                	je     8010139c <filewrite+0xec>
80101397:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  panic("filewrite");
}
8010139c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010139f:	5b                   	pop    %ebx
801013a0:	5e                   	pop    %esi
801013a1:	5f                   	pop    %edi
801013a2:	5d                   	pop    %ebp
801013a3:	c3                   	ret    
    return pipewrite(f->pipe, addr, n);
801013a4:	8b 46 0c             	mov    0xc(%esi),%eax
801013a7:	89 45 08             	mov    %eax,0x8(%ebp)
}
801013aa:	8d 65 f4             	lea    -0xc(%ebp),%esp
801013ad:	5b                   	pop    %ebx
801013ae:	5e                   	pop    %esi
801013af:	5f                   	pop    %edi
801013b0:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
801013b1:	e9 0a 24 00 00       	jmp    801037c0 <pipewrite>
  panic("filewrite");
801013b6:	83 ec 0c             	sub    $0xc,%esp
801013b9:	68 35 74 10 80       	push   $0x80107435
801013be:	e8 cd ef ff ff       	call   80100390 <panic>
801013c3:	66 90                	xchg   %ax,%ax
801013c5:	66 90                	xchg   %ax,%ax
801013c7:	66 90                	xchg   %ax,%ax
801013c9:	66 90                	xchg   %ax,%ax
801013cb:	66 90                	xchg   %ax,%ax
801013cd:	66 90                	xchg   %ax,%ax
801013cf:	90                   	nop

801013d0 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
801013d0:	55                   	push   %ebp
801013d1:	89 c1                	mov    %eax,%ecx
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
801013d3:	89 d0                	mov    %edx,%eax
801013d5:	c1 e8 0c             	shr    $0xc,%eax
801013d8:	03 05 f8 09 11 80    	add    0x801109f8,%eax
{
801013de:	89 e5                	mov    %esp,%ebp
801013e0:	56                   	push   %esi
801013e1:	53                   	push   %ebx
801013e2:	89 d3                	mov    %edx,%ebx
  bp = bread(dev, BBLOCK(b, sb));
801013e4:	83 ec 08             	sub    $0x8,%esp
801013e7:	50                   	push   %eax
801013e8:	51                   	push   %ecx
801013e9:	e8 e2 ec ff ff       	call   801000d0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
801013ee:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
801013f0:	c1 fb 03             	sar    $0x3,%ebx
  m = 1 << (bi % 8);
801013f3:	ba 01 00 00 00       	mov    $0x1,%edx
801013f8:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
801013fb:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
80101401:	83 c4 10             	add    $0x10,%esp
  m = 1 << (bi % 8);
80101404:	d3 e2                	shl    %cl,%edx
  if((bp->data[bi/8] & m) == 0)
80101406:	0f b6 4c 18 5c       	movzbl 0x5c(%eax,%ebx,1),%ecx
8010140b:	85 d1                	test   %edx,%ecx
8010140d:	74 25                	je     80101434 <bfree+0x64>
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
8010140f:	f7 d2                	not    %edx
  log_write(bp);
80101411:	83 ec 0c             	sub    $0xc,%esp
80101414:	89 c6                	mov    %eax,%esi
  bp->data[bi/8] &= ~m;
80101416:	21 ca                	and    %ecx,%edx
80101418:	88 54 18 5c          	mov    %dl,0x5c(%eax,%ebx,1)
  log_write(bp);
8010141c:	50                   	push   %eax
8010141d:	e8 0e 1d 00 00       	call   80103130 <log_write>
  brelse(bp);
80101422:	89 34 24             	mov    %esi,(%esp)
80101425:	e8 c6 ed ff ff       	call   801001f0 <brelse>
}
8010142a:	83 c4 10             	add    $0x10,%esp
8010142d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101430:	5b                   	pop    %ebx
80101431:	5e                   	pop    %esi
80101432:	5d                   	pop    %ebp
80101433:	c3                   	ret    
    panic("freeing free block");
80101434:	83 ec 0c             	sub    $0xc,%esp
80101437:	68 3f 74 10 80       	push   $0x8010743f
8010143c:	e8 4f ef ff ff       	call   80100390 <panic>
80101441:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101448:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010144f:	90                   	nop

80101450 <balloc>:
{
80101450:	55                   	push   %ebp
80101451:	89 e5                	mov    %esp,%ebp
80101453:	57                   	push   %edi
80101454:	56                   	push   %esi
80101455:	53                   	push   %ebx
80101456:	83 ec 1c             	sub    $0x1c,%esp
  for(b = 0; b < sb.size; b += BPB){
80101459:	8b 0d e0 09 11 80    	mov    0x801109e0,%ecx
{
8010145f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
80101462:	85 c9                	test   %ecx,%ecx
80101464:	0f 84 87 00 00 00    	je     801014f1 <balloc+0xa1>
8010146a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
80101471:	8b 75 dc             	mov    -0x24(%ebp),%esi
80101474:	83 ec 08             	sub    $0x8,%esp
80101477:	89 f0                	mov    %esi,%eax
80101479:	c1 f8 0c             	sar    $0xc,%eax
8010147c:	03 05 f8 09 11 80    	add    0x801109f8,%eax
80101482:	50                   	push   %eax
80101483:	ff 75 d8             	pushl  -0x28(%ebp)
80101486:	e8 45 ec ff ff       	call   801000d0 <bread>
8010148b:	83 c4 10             	add    $0x10,%esp
8010148e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101491:	a1 e0 09 11 80       	mov    0x801109e0,%eax
80101496:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101499:	31 c0                	xor    %eax,%eax
8010149b:	eb 2f                	jmp    801014cc <balloc+0x7c>
8010149d:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
801014a0:	89 c1                	mov    %eax,%ecx
801014a2:	bb 01 00 00 00       	mov    $0x1,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801014a7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      m = 1 << (bi % 8);
801014aa:	83 e1 07             	and    $0x7,%ecx
801014ad:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801014af:	89 c1                	mov    %eax,%ecx
801014b1:	c1 f9 03             	sar    $0x3,%ecx
801014b4:	0f b6 7c 0a 5c       	movzbl 0x5c(%edx,%ecx,1),%edi
801014b9:	89 fa                	mov    %edi,%edx
801014bb:	85 df                	test   %ebx,%edi
801014bd:	74 41                	je     80101500 <balloc+0xb0>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801014bf:	83 c0 01             	add    $0x1,%eax
801014c2:	83 c6 01             	add    $0x1,%esi
801014c5:	3d 00 10 00 00       	cmp    $0x1000,%eax
801014ca:	74 05                	je     801014d1 <balloc+0x81>
801014cc:	39 75 e0             	cmp    %esi,-0x20(%ebp)
801014cf:	77 cf                	ja     801014a0 <balloc+0x50>
    brelse(bp);
801014d1:	83 ec 0c             	sub    $0xc,%esp
801014d4:	ff 75 e4             	pushl  -0x1c(%ebp)
801014d7:	e8 14 ed ff ff       	call   801001f0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
801014dc:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
801014e3:	83 c4 10             	add    $0x10,%esp
801014e6:	8b 45 dc             	mov    -0x24(%ebp),%eax
801014e9:	39 05 e0 09 11 80    	cmp    %eax,0x801109e0
801014ef:	77 80                	ja     80101471 <balloc+0x21>
  panic("balloc: out of blocks");
801014f1:	83 ec 0c             	sub    $0xc,%esp
801014f4:	68 52 74 10 80       	push   $0x80107452
801014f9:	e8 92 ee ff ff       	call   80100390 <panic>
801014fe:	66 90                	xchg   %ax,%ax
        bp->data[bi/8] |= m;  // Mark block in use.
80101500:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
80101503:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
80101506:	09 da                	or     %ebx,%edx
80101508:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
8010150c:	57                   	push   %edi
8010150d:	e8 1e 1c 00 00       	call   80103130 <log_write>
        brelse(bp);
80101512:	89 3c 24             	mov    %edi,(%esp)
80101515:	e8 d6 ec ff ff       	call   801001f0 <brelse>
  bp = bread(dev, bno);
8010151a:	58                   	pop    %eax
8010151b:	5a                   	pop    %edx
8010151c:	56                   	push   %esi
8010151d:	ff 75 d8             	pushl  -0x28(%ebp)
80101520:	e8 ab eb ff ff       	call   801000d0 <bread>
  memset(bp->data, 0, BSIZE);
80101525:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, bno);
80101528:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
8010152a:	8d 40 5c             	lea    0x5c(%eax),%eax
8010152d:	68 00 02 00 00       	push   $0x200
80101532:	6a 00                	push   $0x0
80101534:	50                   	push   %eax
80101535:	e8 66 33 00 00       	call   801048a0 <memset>
  log_write(bp);
8010153a:	89 1c 24             	mov    %ebx,(%esp)
8010153d:	e8 ee 1b 00 00       	call   80103130 <log_write>
  brelse(bp);
80101542:	89 1c 24             	mov    %ebx,(%esp)
80101545:	e8 a6 ec ff ff       	call   801001f0 <brelse>
}
8010154a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010154d:	89 f0                	mov    %esi,%eax
8010154f:	5b                   	pop    %ebx
80101550:	5e                   	pop    %esi
80101551:	5f                   	pop    %edi
80101552:	5d                   	pop    %ebp
80101553:	c3                   	ret    
80101554:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010155b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010155f:	90                   	nop

80101560 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101560:	55                   	push   %ebp
80101561:	89 e5                	mov    %esp,%ebp
80101563:	57                   	push   %edi
80101564:	89 c7                	mov    %eax,%edi
80101566:	56                   	push   %esi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101567:	31 f6                	xor    %esi,%esi
{
80101569:	53                   	push   %ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010156a:	bb 34 0a 11 80       	mov    $0x80110a34,%ebx
{
8010156f:	83 ec 28             	sub    $0x28,%esp
80101572:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
80101575:	68 00 0a 11 80       	push   $0x80110a00
8010157a:	e8 11 32 00 00       	call   80104790 <acquire>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010157f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  acquire(&icache.lock);
80101582:	83 c4 10             	add    $0x10,%esp
80101585:	eb 1b                	jmp    801015a2 <iget+0x42>
80101587:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010158e:	66 90                	xchg   %ax,%ax
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101590:	39 3b                	cmp    %edi,(%ebx)
80101592:	74 6c                	je     80101600 <iget+0xa0>
80101594:	81 c3 90 00 00 00    	add    $0x90,%ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010159a:	81 fb 54 26 11 80    	cmp    $0x80112654,%ebx
801015a0:	73 26                	jae    801015c8 <iget+0x68>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801015a2:	8b 4b 08             	mov    0x8(%ebx),%ecx
801015a5:	85 c9                	test   %ecx,%ecx
801015a7:	7f e7                	jg     80101590 <iget+0x30>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
801015a9:	85 f6                	test   %esi,%esi
801015ab:	75 e7                	jne    80101594 <iget+0x34>
801015ad:	89 d8                	mov    %ebx,%eax
801015af:	81 c3 90 00 00 00    	add    $0x90,%ebx
801015b5:	85 c9                	test   %ecx,%ecx
801015b7:	75 6e                	jne    80101627 <iget+0xc7>
801015b9:	89 c6                	mov    %eax,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801015bb:	81 fb 54 26 11 80    	cmp    $0x80112654,%ebx
801015c1:	72 df                	jb     801015a2 <iget+0x42>
801015c3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801015c7:	90                   	nop
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
801015c8:	85 f6                	test   %esi,%esi
801015ca:	74 73                	je     8010163f <iget+0xdf>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
801015cc:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
801015cf:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
801015d1:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
801015d4:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
801015db:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
801015e2:	68 00 0a 11 80       	push   $0x80110a00
801015e7:	e8 64 32 00 00       	call   80104850 <release>

  return ip;
801015ec:	83 c4 10             	add    $0x10,%esp
}
801015ef:	8d 65 f4             	lea    -0xc(%ebp),%esp
801015f2:	89 f0                	mov    %esi,%eax
801015f4:	5b                   	pop    %ebx
801015f5:	5e                   	pop    %esi
801015f6:	5f                   	pop    %edi
801015f7:	5d                   	pop    %ebp
801015f8:	c3                   	ret    
801015f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101600:	39 53 04             	cmp    %edx,0x4(%ebx)
80101603:	75 8f                	jne    80101594 <iget+0x34>
      release(&icache.lock);
80101605:	83 ec 0c             	sub    $0xc,%esp
      ip->ref++;
80101608:	83 c1 01             	add    $0x1,%ecx
      return ip;
8010160b:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
8010160d:	68 00 0a 11 80       	push   $0x80110a00
      ip->ref++;
80101612:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
80101615:	e8 36 32 00 00       	call   80104850 <release>
      return ip;
8010161a:	83 c4 10             	add    $0x10,%esp
}
8010161d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101620:	89 f0                	mov    %esi,%eax
80101622:	5b                   	pop    %ebx
80101623:	5e                   	pop    %esi
80101624:	5f                   	pop    %edi
80101625:	5d                   	pop    %ebp
80101626:	c3                   	ret    
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101627:	81 fb 54 26 11 80    	cmp    $0x80112654,%ebx
8010162d:	73 10                	jae    8010163f <iget+0xdf>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
8010162f:	8b 4b 08             	mov    0x8(%ebx),%ecx
80101632:	85 c9                	test   %ecx,%ecx
80101634:	0f 8f 56 ff ff ff    	jg     80101590 <iget+0x30>
8010163a:	e9 6e ff ff ff       	jmp    801015ad <iget+0x4d>
    panic("iget: no inodes");
8010163f:	83 ec 0c             	sub    $0xc,%esp
80101642:	68 68 74 10 80       	push   $0x80107468
80101647:	e8 44 ed ff ff       	call   80100390 <panic>
8010164c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101650 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101650:	55                   	push   %ebp
80101651:	89 e5                	mov    %esp,%ebp
80101653:	57                   	push   %edi
80101654:	56                   	push   %esi
80101655:	89 c6                	mov    %eax,%esi
80101657:	53                   	push   %ebx
80101658:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
8010165b:	83 fa 0b             	cmp    $0xb,%edx
8010165e:	0f 86 84 00 00 00    	jbe    801016e8 <bmap+0x98>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
80101664:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
80101667:	83 fb 7f             	cmp    $0x7f,%ebx
8010166a:	0f 87 98 00 00 00    	ja     80101708 <bmap+0xb8>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101670:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101676:	8b 16                	mov    (%esi),%edx
80101678:	85 c0                	test   %eax,%eax
8010167a:	74 54                	je     801016d0 <bmap+0x80>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
8010167c:	83 ec 08             	sub    $0x8,%esp
8010167f:	50                   	push   %eax
80101680:	52                   	push   %edx
80101681:	e8 4a ea ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
80101686:	83 c4 10             	add    $0x10,%esp
80101689:	8d 54 98 5c          	lea    0x5c(%eax,%ebx,4),%edx
    bp = bread(ip->dev, addr);
8010168d:	89 c7                	mov    %eax,%edi
    if((addr = a[bn]) == 0){
8010168f:	8b 1a                	mov    (%edx),%ebx
80101691:	85 db                	test   %ebx,%ebx
80101693:	74 1b                	je     801016b0 <bmap+0x60>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
80101695:	83 ec 0c             	sub    $0xc,%esp
80101698:	57                   	push   %edi
80101699:	e8 52 eb ff ff       	call   801001f0 <brelse>
    return addr;
8010169e:	83 c4 10             	add    $0x10,%esp
  }

  panic("bmap: out of range");
}
801016a1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801016a4:	89 d8                	mov    %ebx,%eax
801016a6:	5b                   	pop    %ebx
801016a7:	5e                   	pop    %esi
801016a8:	5f                   	pop    %edi
801016a9:	5d                   	pop    %ebp
801016aa:	c3                   	ret    
801016ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801016af:	90                   	nop
      a[bn] = addr = balloc(ip->dev);
801016b0:	8b 06                	mov    (%esi),%eax
801016b2:	89 55 e4             	mov    %edx,-0x1c(%ebp)
801016b5:	e8 96 fd ff ff       	call   80101450 <balloc>
801016ba:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      log_write(bp);
801016bd:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
801016c0:	89 c3                	mov    %eax,%ebx
801016c2:	89 02                	mov    %eax,(%edx)
      log_write(bp);
801016c4:	57                   	push   %edi
801016c5:	e8 66 1a 00 00       	call   80103130 <log_write>
801016ca:	83 c4 10             	add    $0x10,%esp
801016cd:	eb c6                	jmp    80101695 <bmap+0x45>
801016cf:	90                   	nop
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
801016d0:	89 d0                	mov    %edx,%eax
801016d2:	e8 79 fd ff ff       	call   80101450 <balloc>
801016d7:	8b 16                	mov    (%esi),%edx
801016d9:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
801016df:	eb 9b                	jmp    8010167c <bmap+0x2c>
801016e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if((addr = ip->addrs[bn]) == 0)
801016e8:	8d 3c 90             	lea    (%eax,%edx,4),%edi
801016eb:	8b 5f 5c             	mov    0x5c(%edi),%ebx
801016ee:	85 db                	test   %ebx,%ebx
801016f0:	75 af                	jne    801016a1 <bmap+0x51>
      ip->addrs[bn] = addr = balloc(ip->dev);
801016f2:	8b 00                	mov    (%eax),%eax
801016f4:	e8 57 fd ff ff       	call   80101450 <balloc>
801016f9:	89 47 5c             	mov    %eax,0x5c(%edi)
801016fc:	89 c3                	mov    %eax,%ebx
}
801016fe:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101701:	89 d8                	mov    %ebx,%eax
80101703:	5b                   	pop    %ebx
80101704:	5e                   	pop    %esi
80101705:	5f                   	pop    %edi
80101706:	5d                   	pop    %ebp
80101707:	c3                   	ret    
  panic("bmap: out of range");
80101708:	83 ec 0c             	sub    $0xc,%esp
8010170b:	68 78 74 10 80       	push   $0x80107478
80101710:	e8 7b ec ff ff       	call   80100390 <panic>
80101715:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010171c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101720 <readsb>:
{
80101720:	f3 0f 1e fb          	endbr32 
80101724:	55                   	push   %ebp
80101725:	89 e5                	mov    %esp,%ebp
80101727:	56                   	push   %esi
80101728:	53                   	push   %ebx
80101729:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
8010172c:	83 ec 08             	sub    $0x8,%esp
8010172f:	6a 01                	push   $0x1
80101731:	ff 75 08             	pushl  0x8(%ebp)
80101734:	e8 97 e9 ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
80101739:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
8010173c:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
8010173e:	8d 40 5c             	lea    0x5c(%eax),%eax
80101741:	6a 1c                	push   $0x1c
80101743:	50                   	push   %eax
80101744:	56                   	push   %esi
80101745:	e8 f6 31 00 00       	call   80104940 <memmove>
  brelse(bp);
8010174a:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010174d:	83 c4 10             	add    $0x10,%esp
}
80101750:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101753:	5b                   	pop    %ebx
80101754:	5e                   	pop    %esi
80101755:	5d                   	pop    %ebp
  brelse(bp);
80101756:	e9 95 ea ff ff       	jmp    801001f0 <brelse>
8010175b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010175f:	90                   	nop

80101760 <iinit>:
{
80101760:	f3 0f 1e fb          	endbr32 
80101764:	55                   	push   %ebp
80101765:	89 e5                	mov    %esp,%ebp
80101767:	53                   	push   %ebx
80101768:	bb 40 0a 11 80       	mov    $0x80110a40,%ebx
8010176d:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
80101770:	68 8b 74 10 80       	push   $0x8010748b
80101775:	68 00 0a 11 80       	push   $0x80110a00
8010177a:	e8 91 2e 00 00       	call   80104610 <initlock>
  for(i = 0; i < NINODE; i++) {
8010177f:	83 c4 10             	add    $0x10,%esp
80101782:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    initsleeplock(&icache.inode[i].lock, "inode");
80101788:	83 ec 08             	sub    $0x8,%esp
8010178b:	68 92 74 10 80       	push   $0x80107492
80101790:	53                   	push   %ebx
80101791:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101797:	e8 34 2d 00 00       	call   801044d0 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
8010179c:	83 c4 10             	add    $0x10,%esp
8010179f:	81 fb 60 26 11 80    	cmp    $0x80112660,%ebx
801017a5:	75 e1                	jne    80101788 <iinit+0x28>
  readsb(dev, &sb);
801017a7:	83 ec 08             	sub    $0x8,%esp
801017aa:	68 e0 09 11 80       	push   $0x801109e0
801017af:	ff 75 08             	pushl  0x8(%ebp)
801017b2:	e8 69 ff ff ff       	call   80101720 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
801017b7:	ff 35 f8 09 11 80    	pushl  0x801109f8
801017bd:	ff 35 f4 09 11 80    	pushl  0x801109f4
801017c3:	ff 35 f0 09 11 80    	pushl  0x801109f0
801017c9:	ff 35 ec 09 11 80    	pushl  0x801109ec
801017cf:	ff 35 e8 09 11 80    	pushl  0x801109e8
801017d5:	ff 35 e4 09 11 80    	pushl  0x801109e4
801017db:	ff 35 e0 09 11 80    	pushl  0x801109e0
801017e1:	68 f8 74 10 80       	push   $0x801074f8
801017e6:	e8 35 ef ff ff       	call   80100720 <cprintf>
}
801017eb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801017ee:	83 c4 30             	add    $0x30,%esp
801017f1:	c9                   	leave  
801017f2:	c3                   	ret    
801017f3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801017fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101800 <ialloc>:
{
80101800:	f3 0f 1e fb          	endbr32 
80101804:	55                   	push   %ebp
80101805:	89 e5                	mov    %esp,%ebp
80101807:	57                   	push   %edi
80101808:	56                   	push   %esi
80101809:	53                   	push   %ebx
8010180a:	83 ec 1c             	sub    $0x1c,%esp
8010180d:	8b 45 0c             	mov    0xc(%ebp),%eax
  for(inum = 1; inum < sb.ninodes; inum++){
80101810:	83 3d e8 09 11 80 01 	cmpl   $0x1,0x801109e8
{
80101817:	8b 75 08             	mov    0x8(%ebp),%esi
8010181a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
8010181d:	0f 86 8d 00 00 00    	jbe    801018b0 <ialloc+0xb0>
80101823:	bf 01 00 00 00       	mov    $0x1,%edi
80101828:	eb 1d                	jmp    80101847 <ialloc+0x47>
8010182a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    brelse(bp);
80101830:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101833:	83 c7 01             	add    $0x1,%edi
    brelse(bp);
80101836:	53                   	push   %ebx
80101837:	e8 b4 e9 ff ff       	call   801001f0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
8010183c:	83 c4 10             	add    $0x10,%esp
8010183f:	3b 3d e8 09 11 80    	cmp    0x801109e8,%edi
80101845:	73 69                	jae    801018b0 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101847:	89 f8                	mov    %edi,%eax
80101849:	83 ec 08             	sub    $0x8,%esp
8010184c:	c1 e8 03             	shr    $0x3,%eax
8010184f:	03 05 f4 09 11 80    	add    0x801109f4,%eax
80101855:	50                   	push   %eax
80101856:	56                   	push   %esi
80101857:	e8 74 e8 ff ff       	call   801000d0 <bread>
    if(dip->type == 0){  // a free inode
8010185c:	83 c4 10             	add    $0x10,%esp
    bp = bread(dev, IBLOCK(inum, sb));
8010185f:	89 c3                	mov    %eax,%ebx
    dip = (struct dinode*)bp->data + inum%IPB;
80101861:	89 f8                	mov    %edi,%eax
80101863:	83 e0 07             	and    $0x7,%eax
80101866:	c1 e0 06             	shl    $0x6,%eax
80101869:	8d 4c 03 5c          	lea    0x5c(%ebx,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
8010186d:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101871:	75 bd                	jne    80101830 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101873:	83 ec 04             	sub    $0x4,%esp
80101876:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101879:	6a 40                	push   $0x40
8010187b:	6a 00                	push   $0x0
8010187d:	51                   	push   %ecx
8010187e:	e8 1d 30 00 00       	call   801048a0 <memset>
      dip->type = type;
80101883:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80101887:	8b 4d e0             	mov    -0x20(%ebp),%ecx
8010188a:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
8010188d:	89 1c 24             	mov    %ebx,(%esp)
80101890:	e8 9b 18 00 00       	call   80103130 <log_write>
      brelse(bp);
80101895:	89 1c 24             	mov    %ebx,(%esp)
80101898:	e8 53 e9 ff ff       	call   801001f0 <brelse>
      return iget(dev, inum);
8010189d:	83 c4 10             	add    $0x10,%esp
}
801018a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
801018a3:	89 fa                	mov    %edi,%edx
}
801018a5:	5b                   	pop    %ebx
      return iget(dev, inum);
801018a6:	89 f0                	mov    %esi,%eax
}
801018a8:	5e                   	pop    %esi
801018a9:	5f                   	pop    %edi
801018aa:	5d                   	pop    %ebp
      return iget(dev, inum);
801018ab:	e9 b0 fc ff ff       	jmp    80101560 <iget>
  panic("ialloc: no inodes");
801018b0:	83 ec 0c             	sub    $0xc,%esp
801018b3:	68 98 74 10 80       	push   $0x80107498
801018b8:	e8 d3 ea ff ff       	call   80100390 <panic>
801018bd:	8d 76 00             	lea    0x0(%esi),%esi

801018c0 <iupdate>:
{
801018c0:	f3 0f 1e fb          	endbr32 
801018c4:	55                   	push   %ebp
801018c5:	89 e5                	mov    %esp,%ebp
801018c7:	56                   	push   %esi
801018c8:	53                   	push   %ebx
801018c9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801018cc:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801018cf:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801018d2:	83 ec 08             	sub    $0x8,%esp
801018d5:	c1 e8 03             	shr    $0x3,%eax
801018d8:	03 05 f4 09 11 80    	add    0x801109f4,%eax
801018de:	50                   	push   %eax
801018df:	ff 73 a4             	pushl  -0x5c(%ebx)
801018e2:	e8 e9 e7 ff ff       	call   801000d0 <bread>
  dip->type = ip->type;
801018e7:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801018eb:	83 c4 0c             	add    $0xc,%esp
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801018ee:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801018f0:	8b 43 a8             	mov    -0x58(%ebx),%eax
801018f3:	83 e0 07             	and    $0x7,%eax
801018f6:	c1 e0 06             	shl    $0x6,%eax
801018f9:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
801018fd:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
80101900:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101904:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
80101907:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
8010190b:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
8010190f:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
80101913:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80101917:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
8010191b:	8b 53 fc             	mov    -0x4(%ebx),%edx
8010191e:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101921:	6a 34                	push   $0x34
80101923:	53                   	push   %ebx
80101924:	50                   	push   %eax
80101925:	e8 16 30 00 00       	call   80104940 <memmove>
  log_write(bp);
8010192a:	89 34 24             	mov    %esi,(%esp)
8010192d:	e8 fe 17 00 00       	call   80103130 <log_write>
  brelse(bp);
80101932:	89 75 08             	mov    %esi,0x8(%ebp)
80101935:	83 c4 10             	add    $0x10,%esp
}
80101938:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010193b:	5b                   	pop    %ebx
8010193c:	5e                   	pop    %esi
8010193d:	5d                   	pop    %ebp
  brelse(bp);
8010193e:	e9 ad e8 ff ff       	jmp    801001f0 <brelse>
80101943:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010194a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101950 <idup>:
{
80101950:	f3 0f 1e fb          	endbr32 
80101954:	55                   	push   %ebp
80101955:	89 e5                	mov    %esp,%ebp
80101957:	53                   	push   %ebx
80101958:	83 ec 10             	sub    $0x10,%esp
8010195b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010195e:	68 00 0a 11 80       	push   $0x80110a00
80101963:	e8 28 2e 00 00       	call   80104790 <acquire>
  ip->ref++;
80101968:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
8010196c:	c7 04 24 00 0a 11 80 	movl   $0x80110a00,(%esp)
80101973:	e8 d8 2e 00 00       	call   80104850 <release>
}
80101978:	89 d8                	mov    %ebx,%eax
8010197a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010197d:	c9                   	leave  
8010197e:	c3                   	ret    
8010197f:	90                   	nop

80101980 <ilock>:
{
80101980:	f3 0f 1e fb          	endbr32 
80101984:	55                   	push   %ebp
80101985:	89 e5                	mov    %esp,%ebp
80101987:	56                   	push   %esi
80101988:	53                   	push   %ebx
80101989:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
8010198c:	85 db                	test   %ebx,%ebx
8010198e:	0f 84 b3 00 00 00    	je     80101a47 <ilock+0xc7>
80101994:	8b 53 08             	mov    0x8(%ebx),%edx
80101997:	85 d2                	test   %edx,%edx
80101999:	0f 8e a8 00 00 00    	jle    80101a47 <ilock+0xc7>
  acquiresleep(&ip->lock);
8010199f:	83 ec 0c             	sub    $0xc,%esp
801019a2:	8d 43 0c             	lea    0xc(%ebx),%eax
801019a5:	50                   	push   %eax
801019a6:	e8 65 2b 00 00       	call   80104510 <acquiresleep>
  if(ip->valid == 0){
801019ab:	8b 43 4c             	mov    0x4c(%ebx),%eax
801019ae:	83 c4 10             	add    $0x10,%esp
801019b1:	85 c0                	test   %eax,%eax
801019b3:	74 0b                	je     801019c0 <ilock+0x40>
}
801019b5:	8d 65 f8             	lea    -0x8(%ebp),%esp
801019b8:	5b                   	pop    %ebx
801019b9:	5e                   	pop    %esi
801019ba:	5d                   	pop    %ebp
801019bb:	c3                   	ret    
801019bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801019c0:	8b 43 04             	mov    0x4(%ebx),%eax
801019c3:	83 ec 08             	sub    $0x8,%esp
801019c6:	c1 e8 03             	shr    $0x3,%eax
801019c9:	03 05 f4 09 11 80    	add    0x801109f4,%eax
801019cf:	50                   	push   %eax
801019d0:	ff 33                	pushl  (%ebx)
801019d2:	e8 f9 e6 ff ff       	call   801000d0 <bread>
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801019d7:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801019da:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801019dc:	8b 43 04             	mov    0x4(%ebx),%eax
801019df:	83 e0 07             	and    $0x7,%eax
801019e2:	c1 e0 06             	shl    $0x6,%eax
801019e5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
801019e9:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801019ec:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
801019ef:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
801019f3:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
801019f7:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
801019fb:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
801019ff:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
80101a03:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
80101a07:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
80101a0b:	8b 50 fc             	mov    -0x4(%eax),%edx
80101a0e:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101a11:	6a 34                	push   $0x34
80101a13:	50                   	push   %eax
80101a14:	8d 43 5c             	lea    0x5c(%ebx),%eax
80101a17:	50                   	push   %eax
80101a18:	e8 23 2f 00 00       	call   80104940 <memmove>
    brelse(bp);
80101a1d:	89 34 24             	mov    %esi,(%esp)
80101a20:	e8 cb e7 ff ff       	call   801001f0 <brelse>
    if(ip->type == 0)
80101a25:	83 c4 10             	add    $0x10,%esp
80101a28:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
80101a2d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101a34:	0f 85 7b ff ff ff    	jne    801019b5 <ilock+0x35>
      panic("ilock: no type");
80101a3a:	83 ec 0c             	sub    $0xc,%esp
80101a3d:	68 b0 74 10 80       	push   $0x801074b0
80101a42:	e8 49 e9 ff ff       	call   80100390 <panic>
    panic("ilock");
80101a47:	83 ec 0c             	sub    $0xc,%esp
80101a4a:	68 aa 74 10 80       	push   $0x801074aa
80101a4f:	e8 3c e9 ff ff       	call   80100390 <panic>
80101a54:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101a5b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101a5f:	90                   	nop

80101a60 <iunlock>:
{
80101a60:	f3 0f 1e fb          	endbr32 
80101a64:	55                   	push   %ebp
80101a65:	89 e5                	mov    %esp,%ebp
80101a67:	56                   	push   %esi
80101a68:	53                   	push   %ebx
80101a69:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101a6c:	85 db                	test   %ebx,%ebx
80101a6e:	74 28                	je     80101a98 <iunlock+0x38>
80101a70:	83 ec 0c             	sub    $0xc,%esp
80101a73:	8d 73 0c             	lea    0xc(%ebx),%esi
80101a76:	56                   	push   %esi
80101a77:	e8 34 2b 00 00       	call   801045b0 <holdingsleep>
80101a7c:	83 c4 10             	add    $0x10,%esp
80101a7f:	85 c0                	test   %eax,%eax
80101a81:	74 15                	je     80101a98 <iunlock+0x38>
80101a83:	8b 43 08             	mov    0x8(%ebx),%eax
80101a86:	85 c0                	test   %eax,%eax
80101a88:	7e 0e                	jle    80101a98 <iunlock+0x38>
  releasesleep(&ip->lock);
80101a8a:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101a8d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101a90:	5b                   	pop    %ebx
80101a91:	5e                   	pop    %esi
80101a92:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
80101a93:	e9 d8 2a 00 00       	jmp    80104570 <releasesleep>
    panic("iunlock");
80101a98:	83 ec 0c             	sub    $0xc,%esp
80101a9b:	68 bf 74 10 80       	push   $0x801074bf
80101aa0:	e8 eb e8 ff ff       	call   80100390 <panic>
80101aa5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101aac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101ab0 <iput>:
{
80101ab0:	f3 0f 1e fb          	endbr32 
80101ab4:	55                   	push   %ebp
80101ab5:	89 e5                	mov    %esp,%ebp
80101ab7:	57                   	push   %edi
80101ab8:	56                   	push   %esi
80101ab9:	53                   	push   %ebx
80101aba:	83 ec 28             	sub    $0x28,%esp
80101abd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
80101ac0:	8d 7b 0c             	lea    0xc(%ebx),%edi
80101ac3:	57                   	push   %edi
80101ac4:	e8 47 2a 00 00       	call   80104510 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
80101ac9:	8b 53 4c             	mov    0x4c(%ebx),%edx
80101acc:	83 c4 10             	add    $0x10,%esp
80101acf:	85 d2                	test   %edx,%edx
80101ad1:	74 07                	je     80101ada <iput+0x2a>
80101ad3:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80101ad8:	74 36                	je     80101b10 <iput+0x60>
  releasesleep(&ip->lock);
80101ada:	83 ec 0c             	sub    $0xc,%esp
80101add:	57                   	push   %edi
80101ade:	e8 8d 2a 00 00       	call   80104570 <releasesleep>
  acquire(&icache.lock);
80101ae3:	c7 04 24 00 0a 11 80 	movl   $0x80110a00,(%esp)
80101aea:	e8 a1 2c 00 00       	call   80104790 <acquire>
  ip->ref--;
80101aef:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101af3:	83 c4 10             	add    $0x10,%esp
80101af6:	c7 45 08 00 0a 11 80 	movl   $0x80110a00,0x8(%ebp)
}
80101afd:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b00:	5b                   	pop    %ebx
80101b01:	5e                   	pop    %esi
80101b02:	5f                   	pop    %edi
80101b03:	5d                   	pop    %ebp
  release(&icache.lock);
80101b04:	e9 47 2d 00 00       	jmp    80104850 <release>
80101b09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&icache.lock);
80101b10:	83 ec 0c             	sub    $0xc,%esp
80101b13:	68 00 0a 11 80       	push   $0x80110a00
80101b18:	e8 73 2c 00 00       	call   80104790 <acquire>
    int r = ip->ref;
80101b1d:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101b20:	c7 04 24 00 0a 11 80 	movl   $0x80110a00,(%esp)
80101b27:	e8 24 2d 00 00       	call   80104850 <release>
    if(r == 1){
80101b2c:	83 c4 10             	add    $0x10,%esp
80101b2f:	83 fe 01             	cmp    $0x1,%esi
80101b32:	75 a6                	jne    80101ada <iput+0x2a>
80101b34:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
80101b3a:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101b3d:	8d 73 5c             	lea    0x5c(%ebx),%esi
80101b40:	89 cf                	mov    %ecx,%edi
80101b42:	eb 0b                	jmp    80101b4f <iput+0x9f>
80101b44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101b48:	83 c6 04             	add    $0x4,%esi
80101b4b:	39 fe                	cmp    %edi,%esi
80101b4d:	74 19                	je     80101b68 <iput+0xb8>
    if(ip->addrs[i]){
80101b4f:	8b 16                	mov    (%esi),%edx
80101b51:	85 d2                	test   %edx,%edx
80101b53:	74 f3                	je     80101b48 <iput+0x98>
      bfree(ip->dev, ip->addrs[i]);
80101b55:	8b 03                	mov    (%ebx),%eax
80101b57:	e8 74 f8 ff ff       	call   801013d0 <bfree>
      ip->addrs[i] = 0;
80101b5c:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80101b62:	eb e4                	jmp    80101b48 <iput+0x98>
80101b64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101b68:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
80101b6e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101b71:	85 c0                	test   %eax,%eax
80101b73:	75 33                	jne    80101ba8 <iput+0xf8>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
80101b75:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
80101b78:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
80101b7f:	53                   	push   %ebx
80101b80:	e8 3b fd ff ff       	call   801018c0 <iupdate>
      ip->type = 0;
80101b85:	31 c0                	xor    %eax,%eax
80101b87:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
80101b8b:	89 1c 24             	mov    %ebx,(%esp)
80101b8e:	e8 2d fd ff ff       	call   801018c0 <iupdate>
      ip->valid = 0;
80101b93:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
80101b9a:	83 c4 10             	add    $0x10,%esp
80101b9d:	e9 38 ff ff ff       	jmp    80101ada <iput+0x2a>
80101ba2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101ba8:	83 ec 08             	sub    $0x8,%esp
80101bab:	50                   	push   %eax
80101bac:	ff 33                	pushl  (%ebx)
80101bae:	e8 1d e5 ff ff       	call   801000d0 <bread>
80101bb3:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101bb6:	83 c4 10             	add    $0x10,%esp
80101bb9:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
80101bbf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(j = 0; j < NINDIRECT; j++){
80101bc2:	8d 70 5c             	lea    0x5c(%eax),%esi
80101bc5:	89 cf                	mov    %ecx,%edi
80101bc7:	eb 0e                	jmp    80101bd7 <iput+0x127>
80101bc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101bd0:	83 c6 04             	add    $0x4,%esi
80101bd3:	39 f7                	cmp    %esi,%edi
80101bd5:	74 19                	je     80101bf0 <iput+0x140>
      if(a[j])
80101bd7:	8b 16                	mov    (%esi),%edx
80101bd9:	85 d2                	test   %edx,%edx
80101bdb:	74 f3                	je     80101bd0 <iput+0x120>
        bfree(ip->dev, a[j]);
80101bdd:	8b 03                	mov    (%ebx),%eax
80101bdf:	e8 ec f7 ff ff       	call   801013d0 <bfree>
80101be4:	eb ea                	jmp    80101bd0 <iput+0x120>
80101be6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101bed:	8d 76 00             	lea    0x0(%esi),%esi
    brelse(bp);
80101bf0:	83 ec 0c             	sub    $0xc,%esp
80101bf3:	ff 75 e4             	pushl  -0x1c(%ebp)
80101bf6:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101bf9:	e8 f2 e5 ff ff       	call   801001f0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101bfe:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
80101c04:	8b 03                	mov    (%ebx),%eax
80101c06:	e8 c5 f7 ff ff       	call   801013d0 <bfree>
    ip->addrs[NDIRECT] = 0;
80101c0b:	83 c4 10             	add    $0x10,%esp
80101c0e:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80101c15:	00 00 00 
80101c18:	e9 58 ff ff ff       	jmp    80101b75 <iput+0xc5>
80101c1d:	8d 76 00             	lea    0x0(%esi),%esi

80101c20 <iunlockput>:
{
80101c20:	f3 0f 1e fb          	endbr32 
80101c24:	55                   	push   %ebp
80101c25:	89 e5                	mov    %esp,%ebp
80101c27:	53                   	push   %ebx
80101c28:	83 ec 10             	sub    $0x10,%esp
80101c2b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
80101c2e:	53                   	push   %ebx
80101c2f:	e8 2c fe ff ff       	call   80101a60 <iunlock>
  iput(ip);
80101c34:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101c37:	83 c4 10             	add    $0x10,%esp
}
80101c3a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101c3d:	c9                   	leave  
  iput(ip);
80101c3e:	e9 6d fe ff ff       	jmp    80101ab0 <iput>
80101c43:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101c4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101c50 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101c50:	f3 0f 1e fb          	endbr32 
80101c54:	55                   	push   %ebp
80101c55:	89 e5                	mov    %esp,%ebp
80101c57:	8b 55 08             	mov    0x8(%ebp),%edx
80101c5a:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101c5d:	8b 0a                	mov    (%edx),%ecx
80101c5f:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
80101c62:	8b 4a 04             	mov    0x4(%edx),%ecx
80101c65:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101c68:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101c6c:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
80101c6f:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
80101c73:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101c77:	8b 52 58             	mov    0x58(%edx),%edx
80101c7a:	89 50 10             	mov    %edx,0x10(%eax)
}
80101c7d:	5d                   	pop    %ebp
80101c7e:	c3                   	ret    
80101c7f:	90                   	nop

80101c80 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101c80:	f3 0f 1e fb          	endbr32 
80101c84:	55                   	push   %ebp
80101c85:	89 e5                	mov    %esp,%ebp
80101c87:	57                   	push   %edi
80101c88:	56                   	push   %esi
80101c89:	53                   	push   %ebx
80101c8a:	83 ec 1c             	sub    $0x1c,%esp
80101c8d:	8b 7d 0c             	mov    0xc(%ebp),%edi
80101c90:	8b 45 08             	mov    0x8(%ebp),%eax
80101c93:	8b 75 10             	mov    0x10(%ebp),%esi
80101c96:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101c99:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101c9c:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101ca1:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101ca4:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  if(ip->type == T_DEV){
80101ca7:	0f 84 a3 00 00 00    	je     80101d50 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101cad:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101cb0:	8b 40 58             	mov    0x58(%eax),%eax
80101cb3:	39 c6                	cmp    %eax,%esi
80101cb5:	0f 87 b6 00 00 00    	ja     80101d71 <readi+0xf1>
80101cbb:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101cbe:	31 c9                	xor    %ecx,%ecx
80101cc0:	89 da                	mov    %ebx,%edx
80101cc2:	01 f2                	add    %esi,%edx
80101cc4:	0f 92 c1             	setb   %cl
80101cc7:	89 cf                	mov    %ecx,%edi
80101cc9:	0f 82 a2 00 00 00    	jb     80101d71 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101ccf:	89 c1                	mov    %eax,%ecx
80101cd1:	29 f1                	sub    %esi,%ecx
80101cd3:	39 d0                	cmp    %edx,%eax
80101cd5:	0f 43 cb             	cmovae %ebx,%ecx
80101cd8:	89 4d e4             	mov    %ecx,-0x1c(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101cdb:	85 c9                	test   %ecx,%ecx
80101cdd:	74 63                	je     80101d42 <readi+0xc2>
80101cdf:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101ce0:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101ce3:	89 f2                	mov    %esi,%edx
80101ce5:	c1 ea 09             	shr    $0x9,%edx
80101ce8:	89 d8                	mov    %ebx,%eax
80101cea:	e8 61 f9 ff ff       	call   80101650 <bmap>
80101cef:	83 ec 08             	sub    $0x8,%esp
80101cf2:	50                   	push   %eax
80101cf3:	ff 33                	pushl  (%ebx)
80101cf5:	e8 d6 e3 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101cfa:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101cfd:	b9 00 02 00 00       	mov    $0x200,%ecx
80101d02:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101d05:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101d07:	89 f0                	mov    %esi,%eax
80101d09:	25 ff 01 00 00       	and    $0x1ff,%eax
80101d0e:	29 fb                	sub    %edi,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101d10:	89 55 dc             	mov    %edx,-0x24(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101d13:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80101d15:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101d19:	39 d9                	cmp    %ebx,%ecx
80101d1b:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101d1e:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101d1f:	01 df                	add    %ebx,%edi
80101d21:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80101d23:	50                   	push   %eax
80101d24:	ff 75 e0             	pushl  -0x20(%ebp)
80101d27:	e8 14 2c 00 00       	call   80104940 <memmove>
    brelse(bp);
80101d2c:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101d2f:	89 14 24             	mov    %edx,(%esp)
80101d32:	e8 b9 e4 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101d37:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101d3a:	83 c4 10             	add    $0x10,%esp
80101d3d:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101d40:	77 9e                	ja     80101ce0 <readi+0x60>
  }
  return n;
80101d42:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101d45:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101d48:	5b                   	pop    %ebx
80101d49:	5e                   	pop    %esi
80101d4a:	5f                   	pop    %edi
80101d4b:	5d                   	pop    %ebp
80101d4c:	c3                   	ret    
80101d4d:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101d50:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101d54:	66 83 f8 09          	cmp    $0x9,%ax
80101d58:	77 17                	ja     80101d71 <readi+0xf1>
80101d5a:	8b 04 c5 80 09 11 80 	mov    -0x7feef680(,%eax,8),%eax
80101d61:	85 c0                	test   %eax,%eax
80101d63:	74 0c                	je     80101d71 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80101d65:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101d68:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101d6b:	5b                   	pop    %ebx
80101d6c:	5e                   	pop    %esi
80101d6d:	5f                   	pop    %edi
80101d6e:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101d6f:	ff e0                	jmp    *%eax
      return -1;
80101d71:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101d76:	eb cd                	jmp    80101d45 <readi+0xc5>
80101d78:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101d7f:	90                   	nop

80101d80 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101d80:	f3 0f 1e fb          	endbr32 
80101d84:	55                   	push   %ebp
80101d85:	89 e5                	mov    %esp,%ebp
80101d87:	57                   	push   %edi
80101d88:	56                   	push   %esi
80101d89:	53                   	push   %ebx
80101d8a:	83 ec 1c             	sub    $0x1c,%esp
80101d8d:	8b 45 08             	mov    0x8(%ebp),%eax
80101d90:	8b 75 0c             	mov    0xc(%ebp),%esi
80101d93:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101d96:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101d9b:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101d9e:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101da1:	8b 75 10             	mov    0x10(%ebp),%esi
80101da4:	89 7d e0             	mov    %edi,-0x20(%ebp)
  if(ip->type == T_DEV){
80101da7:	0f 84 b3 00 00 00    	je     80101e60 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101dad:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101db0:	39 70 58             	cmp    %esi,0x58(%eax)
80101db3:	0f 82 e3 00 00 00    	jb     80101e9c <writei+0x11c>
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101db9:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101dbc:	89 f8                	mov    %edi,%eax
80101dbe:	01 f0                	add    %esi,%eax
80101dc0:	0f 82 d6 00 00 00    	jb     80101e9c <writei+0x11c>
80101dc6:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101dcb:	0f 87 cb 00 00 00    	ja     80101e9c <writei+0x11c>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101dd1:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101dd8:	85 ff                	test   %edi,%edi
80101dda:	74 75                	je     80101e51 <writei+0xd1>
80101ddc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101de0:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101de3:	89 f2                	mov    %esi,%edx
80101de5:	c1 ea 09             	shr    $0x9,%edx
80101de8:	89 f8                	mov    %edi,%eax
80101dea:	e8 61 f8 ff ff       	call   80101650 <bmap>
80101def:	83 ec 08             	sub    $0x8,%esp
80101df2:	50                   	push   %eax
80101df3:	ff 37                	pushl  (%edi)
80101df5:	e8 d6 e2 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101dfa:	b9 00 02 00 00       	mov    $0x200,%ecx
80101dff:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101e02:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101e05:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101e07:	89 f0                	mov    %esi,%eax
80101e09:	83 c4 0c             	add    $0xc,%esp
80101e0c:	25 ff 01 00 00       	and    $0x1ff,%eax
80101e11:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101e13:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101e17:	39 d9                	cmp    %ebx,%ecx
80101e19:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101e1c:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101e1d:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
80101e1f:	ff 75 dc             	pushl  -0x24(%ebp)
80101e22:	50                   	push   %eax
80101e23:	e8 18 2b 00 00       	call   80104940 <memmove>
    log_write(bp);
80101e28:	89 3c 24             	mov    %edi,(%esp)
80101e2b:	e8 00 13 00 00       	call   80103130 <log_write>
    brelse(bp);
80101e30:	89 3c 24             	mov    %edi,(%esp)
80101e33:	e8 b8 e3 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101e38:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101e3b:	83 c4 10             	add    $0x10,%esp
80101e3e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101e41:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101e44:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101e47:	77 97                	ja     80101de0 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80101e49:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101e4c:	3b 70 58             	cmp    0x58(%eax),%esi
80101e4f:	77 37                	ja     80101e88 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101e51:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101e54:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101e57:	5b                   	pop    %ebx
80101e58:	5e                   	pop    %esi
80101e59:	5f                   	pop    %edi
80101e5a:	5d                   	pop    %ebp
80101e5b:	c3                   	ret    
80101e5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101e60:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101e64:	66 83 f8 09          	cmp    $0x9,%ax
80101e68:	77 32                	ja     80101e9c <writei+0x11c>
80101e6a:	8b 04 c5 84 09 11 80 	mov    -0x7feef67c(,%eax,8),%eax
80101e71:	85 c0                	test   %eax,%eax
80101e73:	74 27                	je     80101e9c <writei+0x11c>
    return devsw[ip->major].write(ip, src, n);
80101e75:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101e78:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101e7b:	5b                   	pop    %ebx
80101e7c:	5e                   	pop    %esi
80101e7d:	5f                   	pop    %edi
80101e7e:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101e7f:	ff e0                	jmp    *%eax
80101e81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80101e88:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101e8b:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
80101e8e:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101e91:	50                   	push   %eax
80101e92:	e8 29 fa ff ff       	call   801018c0 <iupdate>
80101e97:	83 c4 10             	add    $0x10,%esp
80101e9a:	eb b5                	jmp    80101e51 <writei+0xd1>
      return -1;
80101e9c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101ea1:	eb b1                	jmp    80101e54 <writei+0xd4>
80101ea3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101eaa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101eb0 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101eb0:	f3 0f 1e fb          	endbr32 
80101eb4:	55                   	push   %ebp
80101eb5:	89 e5                	mov    %esp,%ebp
80101eb7:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101eba:	6a 0e                	push   $0xe
80101ebc:	ff 75 0c             	pushl  0xc(%ebp)
80101ebf:	ff 75 08             	pushl  0x8(%ebp)
80101ec2:	e8 e9 2a 00 00       	call   801049b0 <strncmp>
}
80101ec7:	c9                   	leave  
80101ec8:	c3                   	ret    
80101ec9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101ed0 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101ed0:	f3 0f 1e fb          	endbr32 
80101ed4:	55                   	push   %ebp
80101ed5:	89 e5                	mov    %esp,%ebp
80101ed7:	57                   	push   %edi
80101ed8:	56                   	push   %esi
80101ed9:	53                   	push   %ebx
80101eda:	83 ec 1c             	sub    $0x1c,%esp
80101edd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101ee0:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101ee5:	0f 85 89 00 00 00    	jne    80101f74 <dirlookup+0xa4>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101eeb:	8b 53 58             	mov    0x58(%ebx),%edx
80101eee:	31 ff                	xor    %edi,%edi
80101ef0:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101ef3:	85 d2                	test   %edx,%edx
80101ef5:	74 42                	je     80101f39 <dirlookup+0x69>
80101ef7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101efe:	66 90                	xchg   %ax,%ax
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101f00:	6a 10                	push   $0x10
80101f02:	57                   	push   %edi
80101f03:	56                   	push   %esi
80101f04:	53                   	push   %ebx
80101f05:	e8 76 fd ff ff       	call   80101c80 <readi>
80101f0a:	83 c4 10             	add    $0x10,%esp
80101f0d:	83 f8 10             	cmp    $0x10,%eax
80101f10:	75 55                	jne    80101f67 <dirlookup+0x97>
      panic("dirlookup read");
    if(de.inum == 0)
80101f12:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101f17:	74 18                	je     80101f31 <dirlookup+0x61>
  return strncmp(s, t, DIRSIZ);
80101f19:	83 ec 04             	sub    $0x4,%esp
80101f1c:	8d 45 da             	lea    -0x26(%ebp),%eax
80101f1f:	6a 0e                	push   $0xe
80101f21:	50                   	push   %eax
80101f22:	ff 75 0c             	pushl  0xc(%ebp)
80101f25:	e8 86 2a 00 00       	call   801049b0 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101f2a:	83 c4 10             	add    $0x10,%esp
80101f2d:	85 c0                	test   %eax,%eax
80101f2f:	74 17                	je     80101f48 <dirlookup+0x78>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101f31:	83 c7 10             	add    $0x10,%edi
80101f34:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101f37:	72 c7                	jb     80101f00 <dirlookup+0x30>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80101f39:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80101f3c:	31 c0                	xor    %eax,%eax
}
80101f3e:	5b                   	pop    %ebx
80101f3f:	5e                   	pop    %esi
80101f40:	5f                   	pop    %edi
80101f41:	5d                   	pop    %ebp
80101f42:	c3                   	ret    
80101f43:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101f47:	90                   	nop
      if(poff)
80101f48:	8b 45 10             	mov    0x10(%ebp),%eax
80101f4b:	85 c0                	test   %eax,%eax
80101f4d:	74 05                	je     80101f54 <dirlookup+0x84>
        *poff = off;
80101f4f:	8b 45 10             	mov    0x10(%ebp),%eax
80101f52:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101f54:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101f58:	8b 03                	mov    (%ebx),%eax
80101f5a:	e8 01 f6 ff ff       	call   80101560 <iget>
}
80101f5f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f62:	5b                   	pop    %ebx
80101f63:	5e                   	pop    %esi
80101f64:	5f                   	pop    %edi
80101f65:	5d                   	pop    %ebp
80101f66:	c3                   	ret    
      panic("dirlookup read");
80101f67:	83 ec 0c             	sub    $0xc,%esp
80101f6a:	68 d9 74 10 80       	push   $0x801074d9
80101f6f:	e8 1c e4 ff ff       	call   80100390 <panic>
    panic("dirlookup not DIR");
80101f74:	83 ec 0c             	sub    $0xc,%esp
80101f77:	68 c7 74 10 80       	push   $0x801074c7
80101f7c:	e8 0f e4 ff ff       	call   80100390 <panic>
80101f81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101f88:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101f8f:	90                   	nop

80101f90 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101f90:	55                   	push   %ebp
80101f91:	89 e5                	mov    %esp,%ebp
80101f93:	57                   	push   %edi
80101f94:	56                   	push   %esi
80101f95:	53                   	push   %ebx
80101f96:	89 c3                	mov    %eax,%ebx
80101f98:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101f9b:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101f9e:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101fa1:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  if(*path == '/')
80101fa4:	0f 84 86 01 00 00    	je     80102130 <namex+0x1a0>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101faa:	e8 e1 1b 00 00       	call   80103b90 <myproc>
  acquire(&icache.lock);
80101faf:	83 ec 0c             	sub    $0xc,%esp
80101fb2:	89 df                	mov    %ebx,%edi
    ip = idup(myproc()->cwd);
80101fb4:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80101fb7:	68 00 0a 11 80       	push   $0x80110a00
80101fbc:	e8 cf 27 00 00       	call   80104790 <acquire>
  ip->ref++;
80101fc1:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101fc5:	c7 04 24 00 0a 11 80 	movl   $0x80110a00,(%esp)
80101fcc:	e8 7f 28 00 00       	call   80104850 <release>
80101fd1:	83 c4 10             	add    $0x10,%esp
80101fd4:	eb 0d                	jmp    80101fe3 <namex+0x53>
80101fd6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101fdd:	8d 76 00             	lea    0x0(%esi),%esi
    path++;
80101fe0:	83 c7 01             	add    $0x1,%edi
  while(*path == '/')
80101fe3:	0f b6 07             	movzbl (%edi),%eax
80101fe6:	3c 2f                	cmp    $0x2f,%al
80101fe8:	74 f6                	je     80101fe0 <namex+0x50>
  if(*path == 0)
80101fea:	84 c0                	test   %al,%al
80101fec:	0f 84 ee 00 00 00    	je     801020e0 <namex+0x150>
  while(*path != '/' && *path != 0)
80101ff2:	0f b6 07             	movzbl (%edi),%eax
80101ff5:	84 c0                	test   %al,%al
80101ff7:	0f 84 fb 00 00 00    	je     801020f8 <namex+0x168>
80101ffd:	89 fb                	mov    %edi,%ebx
80101fff:	3c 2f                	cmp    $0x2f,%al
80102001:	0f 84 f1 00 00 00    	je     801020f8 <namex+0x168>
80102007:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010200e:	66 90                	xchg   %ax,%ax
80102010:	0f b6 43 01          	movzbl 0x1(%ebx),%eax
    path++;
80102014:	83 c3 01             	add    $0x1,%ebx
  while(*path != '/' && *path != 0)
80102017:	3c 2f                	cmp    $0x2f,%al
80102019:	74 04                	je     8010201f <namex+0x8f>
8010201b:	84 c0                	test   %al,%al
8010201d:	75 f1                	jne    80102010 <namex+0x80>
  len = path - s;
8010201f:	89 d8                	mov    %ebx,%eax
80102021:	29 f8                	sub    %edi,%eax
  if(len >= DIRSIZ)
80102023:	83 f8 0d             	cmp    $0xd,%eax
80102026:	0f 8e 84 00 00 00    	jle    801020b0 <namex+0x120>
    memmove(name, s, DIRSIZ);
8010202c:	83 ec 04             	sub    $0x4,%esp
8010202f:	6a 0e                	push   $0xe
80102031:	57                   	push   %edi
    path++;
80102032:	89 df                	mov    %ebx,%edi
    memmove(name, s, DIRSIZ);
80102034:	ff 75 e4             	pushl  -0x1c(%ebp)
80102037:	e8 04 29 00 00       	call   80104940 <memmove>
8010203c:	83 c4 10             	add    $0x10,%esp
  while(*path == '/')
8010203f:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80102042:	75 0c                	jne    80102050 <namex+0xc0>
80102044:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80102048:	83 c7 01             	add    $0x1,%edi
  while(*path == '/')
8010204b:	80 3f 2f             	cmpb   $0x2f,(%edi)
8010204e:	74 f8                	je     80102048 <namex+0xb8>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80102050:	83 ec 0c             	sub    $0xc,%esp
80102053:	56                   	push   %esi
80102054:	e8 27 f9 ff ff       	call   80101980 <ilock>
    if(ip->type != T_DIR){
80102059:	83 c4 10             	add    $0x10,%esp
8010205c:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80102061:	0f 85 a1 00 00 00    	jne    80102108 <namex+0x178>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80102067:	8b 55 e0             	mov    -0x20(%ebp),%edx
8010206a:	85 d2                	test   %edx,%edx
8010206c:	74 09                	je     80102077 <namex+0xe7>
8010206e:	80 3f 00             	cmpb   $0x0,(%edi)
80102071:	0f 84 d9 00 00 00    	je     80102150 <namex+0x1c0>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80102077:	83 ec 04             	sub    $0x4,%esp
8010207a:	6a 00                	push   $0x0
8010207c:	ff 75 e4             	pushl  -0x1c(%ebp)
8010207f:	56                   	push   %esi
80102080:	e8 4b fe ff ff       	call   80101ed0 <dirlookup>
80102085:	83 c4 10             	add    $0x10,%esp
80102088:	89 c3                	mov    %eax,%ebx
8010208a:	85 c0                	test   %eax,%eax
8010208c:	74 7a                	je     80102108 <namex+0x178>
  iunlock(ip);
8010208e:	83 ec 0c             	sub    $0xc,%esp
80102091:	56                   	push   %esi
80102092:	e8 c9 f9 ff ff       	call   80101a60 <iunlock>
  iput(ip);
80102097:	89 34 24             	mov    %esi,(%esp)
8010209a:	89 de                	mov    %ebx,%esi
8010209c:	e8 0f fa ff ff       	call   80101ab0 <iput>
801020a1:	83 c4 10             	add    $0x10,%esp
801020a4:	e9 3a ff ff ff       	jmp    80101fe3 <namex+0x53>
801020a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801020b0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801020b3:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
801020b6:	89 4d dc             	mov    %ecx,-0x24(%ebp)
    memmove(name, s, len);
801020b9:	83 ec 04             	sub    $0x4,%esp
801020bc:	50                   	push   %eax
801020bd:	57                   	push   %edi
    name[len] = 0;
801020be:	89 df                	mov    %ebx,%edi
    memmove(name, s, len);
801020c0:	ff 75 e4             	pushl  -0x1c(%ebp)
801020c3:	e8 78 28 00 00       	call   80104940 <memmove>
    name[len] = 0;
801020c8:	8b 45 dc             	mov    -0x24(%ebp),%eax
801020cb:	83 c4 10             	add    $0x10,%esp
801020ce:	c6 00 00             	movb   $0x0,(%eax)
801020d1:	e9 69 ff ff ff       	jmp    8010203f <namex+0xaf>
801020d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801020dd:	8d 76 00             	lea    0x0(%esi),%esi
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
801020e0:	8b 45 e0             	mov    -0x20(%ebp),%eax
801020e3:	85 c0                	test   %eax,%eax
801020e5:	0f 85 85 00 00 00    	jne    80102170 <namex+0x1e0>
    iput(ip);
    return 0;
  }
  return ip;
}
801020eb:	8d 65 f4             	lea    -0xc(%ebp),%esp
801020ee:	89 f0                	mov    %esi,%eax
801020f0:	5b                   	pop    %ebx
801020f1:	5e                   	pop    %esi
801020f2:	5f                   	pop    %edi
801020f3:	5d                   	pop    %ebp
801020f4:	c3                   	ret    
801020f5:	8d 76 00             	lea    0x0(%esi),%esi
  while(*path != '/' && *path != 0)
801020f8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801020fb:	89 fb                	mov    %edi,%ebx
801020fd:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102100:	31 c0                	xor    %eax,%eax
80102102:	eb b5                	jmp    801020b9 <namex+0x129>
80102104:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  iunlock(ip);
80102108:	83 ec 0c             	sub    $0xc,%esp
8010210b:	56                   	push   %esi
8010210c:	e8 4f f9 ff ff       	call   80101a60 <iunlock>
  iput(ip);
80102111:	89 34 24             	mov    %esi,(%esp)
      return 0;
80102114:	31 f6                	xor    %esi,%esi
  iput(ip);
80102116:	e8 95 f9 ff ff       	call   80101ab0 <iput>
      return 0;
8010211b:	83 c4 10             	add    $0x10,%esp
}
8010211e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102121:	89 f0                	mov    %esi,%eax
80102123:	5b                   	pop    %ebx
80102124:	5e                   	pop    %esi
80102125:	5f                   	pop    %edi
80102126:	5d                   	pop    %ebp
80102127:	c3                   	ret    
80102128:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010212f:	90                   	nop
    ip = iget(ROOTDEV, ROOTINO);
80102130:	ba 01 00 00 00       	mov    $0x1,%edx
80102135:	b8 01 00 00 00       	mov    $0x1,%eax
8010213a:	89 df                	mov    %ebx,%edi
8010213c:	e8 1f f4 ff ff       	call   80101560 <iget>
80102141:	89 c6                	mov    %eax,%esi
80102143:	e9 9b fe ff ff       	jmp    80101fe3 <namex+0x53>
80102148:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010214f:	90                   	nop
      iunlock(ip);
80102150:	83 ec 0c             	sub    $0xc,%esp
80102153:	56                   	push   %esi
80102154:	e8 07 f9 ff ff       	call   80101a60 <iunlock>
      return ip;
80102159:	83 c4 10             	add    $0x10,%esp
}
8010215c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010215f:	89 f0                	mov    %esi,%eax
80102161:	5b                   	pop    %ebx
80102162:	5e                   	pop    %esi
80102163:	5f                   	pop    %edi
80102164:	5d                   	pop    %ebp
80102165:	c3                   	ret    
80102166:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010216d:	8d 76 00             	lea    0x0(%esi),%esi
    iput(ip);
80102170:	83 ec 0c             	sub    $0xc,%esp
80102173:	56                   	push   %esi
    return 0;
80102174:	31 f6                	xor    %esi,%esi
    iput(ip);
80102176:	e8 35 f9 ff ff       	call   80101ab0 <iput>
    return 0;
8010217b:	83 c4 10             	add    $0x10,%esp
8010217e:	e9 68 ff ff ff       	jmp    801020eb <namex+0x15b>
80102183:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010218a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102190 <dirlink>:
{
80102190:	f3 0f 1e fb          	endbr32 
80102194:	55                   	push   %ebp
80102195:	89 e5                	mov    %esp,%ebp
80102197:	57                   	push   %edi
80102198:	56                   	push   %esi
80102199:	53                   	push   %ebx
8010219a:	83 ec 20             	sub    $0x20,%esp
8010219d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
801021a0:	6a 00                	push   $0x0
801021a2:	ff 75 0c             	pushl  0xc(%ebp)
801021a5:	53                   	push   %ebx
801021a6:	e8 25 fd ff ff       	call   80101ed0 <dirlookup>
801021ab:	83 c4 10             	add    $0x10,%esp
801021ae:	85 c0                	test   %eax,%eax
801021b0:	75 6b                	jne    8010221d <dirlink+0x8d>
  for(off = 0; off < dp->size; off += sizeof(de)){
801021b2:	8b 7b 58             	mov    0x58(%ebx),%edi
801021b5:	8d 75 d8             	lea    -0x28(%ebp),%esi
801021b8:	85 ff                	test   %edi,%edi
801021ba:	74 2d                	je     801021e9 <dirlink+0x59>
801021bc:	31 ff                	xor    %edi,%edi
801021be:	8d 75 d8             	lea    -0x28(%ebp),%esi
801021c1:	eb 0d                	jmp    801021d0 <dirlink+0x40>
801021c3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801021c7:	90                   	nop
801021c8:	83 c7 10             	add    $0x10,%edi
801021cb:	3b 7b 58             	cmp    0x58(%ebx),%edi
801021ce:	73 19                	jae    801021e9 <dirlink+0x59>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801021d0:	6a 10                	push   $0x10
801021d2:	57                   	push   %edi
801021d3:	56                   	push   %esi
801021d4:	53                   	push   %ebx
801021d5:	e8 a6 fa ff ff       	call   80101c80 <readi>
801021da:	83 c4 10             	add    $0x10,%esp
801021dd:	83 f8 10             	cmp    $0x10,%eax
801021e0:	75 4e                	jne    80102230 <dirlink+0xa0>
    if(de.inum == 0)
801021e2:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
801021e7:	75 df                	jne    801021c8 <dirlink+0x38>
  strncpy(de.name, name, DIRSIZ);
801021e9:	83 ec 04             	sub    $0x4,%esp
801021ec:	8d 45 da             	lea    -0x26(%ebp),%eax
801021ef:	6a 0e                	push   $0xe
801021f1:	ff 75 0c             	pushl  0xc(%ebp)
801021f4:	50                   	push   %eax
801021f5:	e8 06 28 00 00       	call   80104a00 <strncpy>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801021fa:	6a 10                	push   $0x10
  de.inum = inum;
801021fc:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801021ff:	57                   	push   %edi
80102200:	56                   	push   %esi
80102201:	53                   	push   %ebx
  de.inum = inum;
80102202:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102206:	e8 75 fb ff ff       	call   80101d80 <writei>
8010220b:	83 c4 20             	add    $0x20,%esp
8010220e:	83 f8 10             	cmp    $0x10,%eax
80102211:	75 2a                	jne    8010223d <dirlink+0xad>
  return 0;
80102213:	31 c0                	xor    %eax,%eax
}
80102215:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102218:	5b                   	pop    %ebx
80102219:	5e                   	pop    %esi
8010221a:	5f                   	pop    %edi
8010221b:	5d                   	pop    %ebp
8010221c:	c3                   	ret    
    iput(ip);
8010221d:	83 ec 0c             	sub    $0xc,%esp
80102220:	50                   	push   %eax
80102221:	e8 8a f8 ff ff       	call   80101ab0 <iput>
    return -1;
80102226:	83 c4 10             	add    $0x10,%esp
80102229:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010222e:	eb e5                	jmp    80102215 <dirlink+0x85>
      panic("dirlink read");
80102230:	83 ec 0c             	sub    $0xc,%esp
80102233:	68 e8 74 10 80       	push   $0x801074e8
80102238:	e8 53 e1 ff ff       	call   80100390 <panic>
    panic("dirlink");
8010223d:	83 ec 0c             	sub    $0xc,%esp
80102240:	68 c6 7a 10 80       	push   $0x80107ac6
80102245:	e8 46 e1 ff ff       	call   80100390 <panic>
8010224a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102250 <namei>:

struct inode*
namei(char *path)
{
80102250:	f3 0f 1e fb          	endbr32 
80102254:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80102255:	31 d2                	xor    %edx,%edx
{
80102257:	89 e5                	mov    %esp,%ebp
80102259:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
8010225c:	8b 45 08             	mov    0x8(%ebp),%eax
8010225f:	8d 4d ea             	lea    -0x16(%ebp),%ecx
80102262:	e8 29 fd ff ff       	call   80101f90 <namex>
}
80102267:	c9                   	leave  
80102268:	c3                   	ret    
80102269:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102270 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80102270:	f3 0f 1e fb          	endbr32 
80102274:	55                   	push   %ebp
  return namex(path, 1, name);
80102275:	ba 01 00 00 00       	mov    $0x1,%edx
{
8010227a:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
8010227c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010227f:	8b 45 08             	mov    0x8(%ebp),%eax
}
80102282:	5d                   	pop    %ebp
  return namex(path, 1, name);
80102283:	e9 08 fd ff ff       	jmp    80101f90 <namex>
80102288:	66 90                	xchg   %ax,%ax
8010228a:	66 90                	xchg   %ax,%ax
8010228c:	66 90                	xchg   %ax,%ax
8010228e:	66 90                	xchg   %ax,%ax

80102290 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80102290:	55                   	push   %ebp
80102291:	89 e5                	mov    %esp,%ebp
80102293:	57                   	push   %edi
80102294:	56                   	push   %esi
80102295:	53                   	push   %ebx
80102296:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
80102299:	85 c0                	test   %eax,%eax
8010229b:	0f 84 b4 00 00 00    	je     80102355 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
801022a1:	8b 70 08             	mov    0x8(%eax),%esi
801022a4:	89 c3                	mov    %eax,%ebx
801022a6:	81 fe e7 03 00 00    	cmp    $0x3e7,%esi
801022ac:	0f 87 96 00 00 00    	ja     80102348 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801022b2:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
801022b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801022be:	66 90                	xchg   %ax,%ax
801022c0:	89 ca                	mov    %ecx,%edx
801022c2:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801022c3:	83 e0 c0             	and    $0xffffffc0,%eax
801022c6:	3c 40                	cmp    $0x40,%al
801022c8:	75 f6                	jne    801022c0 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801022ca:	31 ff                	xor    %edi,%edi
801022cc:	ba f6 03 00 00       	mov    $0x3f6,%edx
801022d1:	89 f8                	mov    %edi,%eax
801022d3:	ee                   	out    %al,(%dx)
801022d4:	b8 01 00 00 00       	mov    $0x1,%eax
801022d9:	ba f2 01 00 00       	mov    $0x1f2,%edx
801022de:	ee                   	out    %al,(%dx)
801022df:	ba f3 01 00 00       	mov    $0x1f3,%edx
801022e4:	89 f0                	mov    %esi,%eax
801022e6:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
801022e7:	89 f0                	mov    %esi,%eax
801022e9:	ba f4 01 00 00       	mov    $0x1f4,%edx
801022ee:	c1 f8 08             	sar    $0x8,%eax
801022f1:	ee                   	out    %al,(%dx)
801022f2:	ba f5 01 00 00       	mov    $0x1f5,%edx
801022f7:	89 f8                	mov    %edi,%eax
801022f9:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
801022fa:	0f b6 43 04          	movzbl 0x4(%ebx),%eax
801022fe:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102303:	c1 e0 04             	shl    $0x4,%eax
80102306:	83 e0 10             	and    $0x10,%eax
80102309:	83 c8 e0             	or     $0xffffffe0,%eax
8010230c:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
8010230d:	f6 03 04             	testb  $0x4,(%ebx)
80102310:	75 16                	jne    80102328 <idestart+0x98>
80102312:	b8 20 00 00 00       	mov    $0x20,%eax
80102317:	89 ca                	mov    %ecx,%edx
80102319:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
8010231a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010231d:	5b                   	pop    %ebx
8010231e:	5e                   	pop    %esi
8010231f:	5f                   	pop    %edi
80102320:	5d                   	pop    %ebp
80102321:	c3                   	ret    
80102322:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102328:	b8 30 00 00 00       	mov    $0x30,%eax
8010232d:	89 ca                	mov    %ecx,%edx
8010232f:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
80102330:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
80102335:	8d 73 5c             	lea    0x5c(%ebx),%esi
80102338:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010233d:	fc                   	cld    
8010233e:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
80102340:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102343:	5b                   	pop    %ebx
80102344:	5e                   	pop    %esi
80102345:	5f                   	pop    %edi
80102346:	5d                   	pop    %ebp
80102347:	c3                   	ret    
    panic("incorrect blockno");
80102348:	83 ec 0c             	sub    $0xc,%esp
8010234b:	68 54 75 10 80       	push   $0x80107554
80102350:	e8 3b e0 ff ff       	call   80100390 <panic>
    panic("idestart");
80102355:	83 ec 0c             	sub    $0xc,%esp
80102358:	68 4b 75 10 80       	push   $0x8010754b
8010235d:	e8 2e e0 ff ff       	call   80100390 <panic>
80102362:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102369:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102370 <ideinit>:
{
80102370:	f3 0f 1e fb          	endbr32 
80102374:	55                   	push   %ebp
80102375:	89 e5                	mov    %esp,%ebp
80102377:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
8010237a:	68 66 75 10 80       	push   $0x80107566
8010237f:	68 a0 a5 10 80       	push   $0x8010a5a0
80102384:	e8 87 22 00 00       	call   80104610 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80102389:	58                   	pop    %eax
8010238a:	a1 20 2d 11 80       	mov    0x80112d20,%eax
8010238f:	5a                   	pop    %edx
80102390:	83 e8 01             	sub    $0x1,%eax
80102393:	50                   	push   %eax
80102394:	6a 0e                	push   $0xe
80102396:	e8 b5 02 00 00       	call   80102650 <ioapicenable>
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
8010239b:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010239e:	ba f7 01 00 00       	mov    $0x1f7,%edx
801023a3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801023a7:	90                   	nop
801023a8:	ec                   	in     (%dx),%al
801023a9:	83 e0 c0             	and    $0xffffffc0,%eax
801023ac:	3c 40                	cmp    $0x40,%al
801023ae:	75 f8                	jne    801023a8 <ideinit+0x38>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801023b0:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
801023b5:	ba f6 01 00 00       	mov    $0x1f6,%edx
801023ba:	ee                   	out    %al,(%dx)
801023bb:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801023c0:	ba f7 01 00 00       	mov    $0x1f7,%edx
801023c5:	eb 0e                	jmp    801023d5 <ideinit+0x65>
801023c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801023ce:	66 90                	xchg   %ax,%ax
  for(i=0; i<1000; i++){
801023d0:	83 e9 01             	sub    $0x1,%ecx
801023d3:	74 0f                	je     801023e4 <ideinit+0x74>
801023d5:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
801023d6:	84 c0                	test   %al,%al
801023d8:	74 f6                	je     801023d0 <ideinit+0x60>
      havedisk1 = 1;
801023da:	c7 05 80 a5 10 80 01 	movl   $0x1,0x8010a580
801023e1:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801023e4:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
801023e9:	ba f6 01 00 00       	mov    $0x1f6,%edx
801023ee:	ee                   	out    %al,(%dx)
}
801023ef:	c9                   	leave  
801023f0:	c3                   	ret    
801023f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801023f8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801023ff:	90                   	nop

80102400 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80102400:	f3 0f 1e fb          	endbr32 
80102404:	55                   	push   %ebp
80102405:	89 e5                	mov    %esp,%ebp
80102407:	57                   	push   %edi
80102408:	56                   	push   %esi
80102409:	53                   	push   %ebx
8010240a:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
8010240d:	68 a0 a5 10 80       	push   $0x8010a5a0
80102412:	e8 79 23 00 00       	call   80104790 <acquire>

  if((b = idequeue) == 0){
80102417:	8b 1d 84 a5 10 80    	mov    0x8010a584,%ebx
8010241d:	83 c4 10             	add    $0x10,%esp
80102420:	85 db                	test   %ebx,%ebx
80102422:	74 5f                	je     80102483 <ideintr+0x83>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80102424:	8b 43 58             	mov    0x58(%ebx),%eax
80102427:	a3 84 a5 10 80       	mov    %eax,0x8010a584

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
8010242c:	8b 33                	mov    (%ebx),%esi
8010242e:	f7 c6 04 00 00 00    	test   $0x4,%esi
80102434:	75 2b                	jne    80102461 <ideintr+0x61>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102436:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010243b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010243f:	90                   	nop
80102440:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102441:	89 c1                	mov    %eax,%ecx
80102443:	83 e1 c0             	and    $0xffffffc0,%ecx
80102446:	80 f9 40             	cmp    $0x40,%cl
80102449:	75 f5                	jne    80102440 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
8010244b:	a8 21                	test   $0x21,%al
8010244d:	75 12                	jne    80102461 <ideintr+0x61>
    insl(0x1f0, b->data, BSIZE/4);
8010244f:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
80102452:	b9 80 00 00 00       	mov    $0x80,%ecx
80102457:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010245c:	fc                   	cld    
8010245d:	f3 6d                	rep insl (%dx),%es:(%edi)
8010245f:	8b 33                	mov    (%ebx),%esi

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
80102461:	83 e6 fb             	and    $0xfffffffb,%esi
  wakeup(b);
80102464:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
80102467:	83 ce 02             	or     $0x2,%esi
8010246a:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
8010246c:	53                   	push   %ebx
8010246d:	e8 9e 1e 00 00       	call   80104310 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80102472:	a1 84 a5 10 80       	mov    0x8010a584,%eax
80102477:	83 c4 10             	add    $0x10,%esp
8010247a:	85 c0                	test   %eax,%eax
8010247c:	74 05                	je     80102483 <ideintr+0x83>
    idestart(idequeue);
8010247e:	e8 0d fe ff ff       	call   80102290 <idestart>
    release(&idelock);
80102483:	83 ec 0c             	sub    $0xc,%esp
80102486:	68 a0 a5 10 80       	push   $0x8010a5a0
8010248b:	e8 c0 23 00 00       	call   80104850 <release>

  release(&idelock);
}
80102490:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102493:	5b                   	pop    %ebx
80102494:	5e                   	pop    %esi
80102495:	5f                   	pop    %edi
80102496:	5d                   	pop    %ebp
80102497:	c3                   	ret    
80102498:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010249f:	90                   	nop

801024a0 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
801024a0:	f3 0f 1e fb          	endbr32 
801024a4:	55                   	push   %ebp
801024a5:	89 e5                	mov    %esp,%ebp
801024a7:	53                   	push   %ebx
801024a8:	83 ec 10             	sub    $0x10,%esp
801024ab:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
801024ae:	8d 43 0c             	lea    0xc(%ebx),%eax
801024b1:	50                   	push   %eax
801024b2:	e8 f9 20 00 00       	call   801045b0 <holdingsleep>
801024b7:	83 c4 10             	add    $0x10,%esp
801024ba:	85 c0                	test   %eax,%eax
801024bc:	0f 84 cf 00 00 00    	je     80102591 <iderw+0xf1>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
801024c2:	8b 03                	mov    (%ebx),%eax
801024c4:	83 e0 06             	and    $0x6,%eax
801024c7:	83 f8 02             	cmp    $0x2,%eax
801024ca:	0f 84 b4 00 00 00    	je     80102584 <iderw+0xe4>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
801024d0:	8b 53 04             	mov    0x4(%ebx),%edx
801024d3:	85 d2                	test   %edx,%edx
801024d5:	74 0d                	je     801024e4 <iderw+0x44>
801024d7:	a1 80 a5 10 80       	mov    0x8010a580,%eax
801024dc:	85 c0                	test   %eax,%eax
801024de:	0f 84 93 00 00 00    	je     80102577 <iderw+0xd7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
801024e4:	83 ec 0c             	sub    $0xc,%esp
801024e7:	68 a0 a5 10 80       	push   $0x8010a5a0
801024ec:	e8 9f 22 00 00       	call   80104790 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801024f1:	a1 84 a5 10 80       	mov    0x8010a584,%eax
  b->qnext = 0;
801024f6:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801024fd:	83 c4 10             	add    $0x10,%esp
80102500:	85 c0                	test   %eax,%eax
80102502:	74 6c                	je     80102570 <iderw+0xd0>
80102504:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102508:	89 c2                	mov    %eax,%edx
8010250a:	8b 40 58             	mov    0x58(%eax),%eax
8010250d:	85 c0                	test   %eax,%eax
8010250f:	75 f7                	jne    80102508 <iderw+0x68>
80102511:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
80102514:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
80102516:	39 1d 84 a5 10 80    	cmp    %ebx,0x8010a584
8010251c:	74 42                	je     80102560 <iderw+0xc0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010251e:	8b 03                	mov    (%ebx),%eax
80102520:	83 e0 06             	and    $0x6,%eax
80102523:	83 f8 02             	cmp    $0x2,%eax
80102526:	74 23                	je     8010254b <iderw+0xab>
80102528:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010252f:	90                   	nop
    sleep(b, &idelock);
80102530:	83 ec 08             	sub    $0x8,%esp
80102533:	68 a0 a5 10 80       	push   $0x8010a5a0
80102538:	53                   	push   %ebx
80102539:	e8 12 1c 00 00       	call   80104150 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010253e:	8b 03                	mov    (%ebx),%eax
80102540:	83 c4 10             	add    $0x10,%esp
80102543:	83 e0 06             	and    $0x6,%eax
80102546:	83 f8 02             	cmp    $0x2,%eax
80102549:	75 e5                	jne    80102530 <iderw+0x90>
  }


  release(&idelock);
8010254b:	c7 45 08 a0 a5 10 80 	movl   $0x8010a5a0,0x8(%ebp)
}
80102552:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102555:	c9                   	leave  
  release(&idelock);
80102556:	e9 f5 22 00 00       	jmp    80104850 <release>
8010255b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010255f:	90                   	nop
    idestart(b);
80102560:	89 d8                	mov    %ebx,%eax
80102562:	e8 29 fd ff ff       	call   80102290 <idestart>
80102567:	eb b5                	jmp    8010251e <iderw+0x7e>
80102569:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102570:	ba 84 a5 10 80       	mov    $0x8010a584,%edx
80102575:	eb 9d                	jmp    80102514 <iderw+0x74>
    panic("iderw: ide disk 1 not present");
80102577:	83 ec 0c             	sub    $0xc,%esp
8010257a:	68 95 75 10 80       	push   $0x80107595
8010257f:	e8 0c de ff ff       	call   80100390 <panic>
    panic("iderw: nothing to do");
80102584:	83 ec 0c             	sub    $0xc,%esp
80102587:	68 80 75 10 80       	push   $0x80107580
8010258c:	e8 ff dd ff ff       	call   80100390 <panic>
    panic("iderw: buf not locked");
80102591:	83 ec 0c             	sub    $0xc,%esp
80102594:	68 6a 75 10 80       	push   $0x8010756a
80102599:	e8 f2 dd ff ff       	call   80100390 <panic>
8010259e:	66 90                	xchg   %ax,%ax

801025a0 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
801025a0:	f3 0f 1e fb          	endbr32 
801025a4:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
801025a5:	c7 05 54 26 11 80 00 	movl   $0xfec00000,0x80112654
801025ac:	00 c0 fe 
{
801025af:	89 e5                	mov    %esp,%ebp
801025b1:	56                   	push   %esi
801025b2:	53                   	push   %ebx
  ioapic->reg = reg;
801025b3:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
801025ba:	00 00 00 
  return ioapic->data;
801025bd:	8b 15 54 26 11 80    	mov    0x80112654,%edx
801025c3:	8b 72 10             	mov    0x10(%edx),%esi
  ioapic->reg = reg;
801025c6:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
801025cc:	8b 0d 54 26 11 80    	mov    0x80112654,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
801025d2:	0f b6 15 80 27 11 80 	movzbl 0x80112780,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
801025d9:	c1 ee 10             	shr    $0x10,%esi
801025dc:	89 f0                	mov    %esi,%eax
801025de:	0f b6 f0             	movzbl %al,%esi
  return ioapic->data;
801025e1:	8b 41 10             	mov    0x10(%ecx),%eax
  id = ioapicread(REG_ID) >> 24;
801025e4:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
801025e7:	39 c2                	cmp    %eax,%edx
801025e9:	74 16                	je     80102601 <ioapicinit+0x61>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
801025eb:	83 ec 0c             	sub    $0xc,%esp
801025ee:	68 b4 75 10 80       	push   $0x801075b4
801025f3:	e8 28 e1 ff ff       	call   80100720 <cprintf>
801025f8:	8b 0d 54 26 11 80    	mov    0x80112654,%ecx
801025fe:	83 c4 10             	add    $0x10,%esp
80102601:	83 c6 21             	add    $0x21,%esi
{
80102604:	ba 10 00 00 00       	mov    $0x10,%edx
80102609:	b8 20 00 00 00       	mov    $0x20,%eax
8010260e:	66 90                	xchg   %ax,%ax
  ioapic->reg = reg;
80102610:	89 11                	mov    %edx,(%ecx)

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102612:	89 c3                	mov    %eax,%ebx
  ioapic->data = data;
80102614:	8b 0d 54 26 11 80    	mov    0x80112654,%ecx
8010261a:	83 c0 01             	add    $0x1,%eax
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
8010261d:	81 cb 00 00 01 00    	or     $0x10000,%ebx
  ioapic->data = data;
80102623:	89 59 10             	mov    %ebx,0x10(%ecx)
  ioapic->reg = reg;
80102626:	8d 5a 01             	lea    0x1(%edx),%ebx
80102629:	83 c2 02             	add    $0x2,%edx
8010262c:	89 19                	mov    %ebx,(%ecx)
  ioapic->data = data;
8010262e:	8b 0d 54 26 11 80    	mov    0x80112654,%ecx
80102634:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
8010263b:	39 f0                	cmp    %esi,%eax
8010263d:	75 d1                	jne    80102610 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
8010263f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102642:	5b                   	pop    %ebx
80102643:	5e                   	pop    %esi
80102644:	5d                   	pop    %ebp
80102645:	c3                   	ret    
80102646:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010264d:	8d 76 00             	lea    0x0(%esi),%esi

80102650 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102650:	f3 0f 1e fb          	endbr32 
80102654:	55                   	push   %ebp
  ioapic->reg = reg;
80102655:	8b 0d 54 26 11 80    	mov    0x80112654,%ecx
{
8010265b:	89 e5                	mov    %esp,%ebp
8010265d:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
80102660:	8d 50 20             	lea    0x20(%eax),%edx
80102663:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
80102667:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102669:	8b 0d 54 26 11 80    	mov    0x80112654,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010266f:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
80102672:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102675:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
80102678:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
8010267a:	a1 54 26 11 80       	mov    0x80112654,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010267f:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
80102682:	89 50 10             	mov    %edx,0x10(%eax)
}
80102685:	5d                   	pop    %ebp
80102686:	c3                   	ret    
80102687:	66 90                	xchg   %ax,%ax
80102689:	66 90                	xchg   %ax,%ax
8010268b:	66 90                	xchg   %ax,%ax
8010268d:	66 90                	xchg   %ax,%ax
8010268f:	90                   	nop

80102690 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102690:	f3 0f 1e fb          	endbr32 
80102694:	55                   	push   %ebp
80102695:	89 e5                	mov    %esp,%ebp
80102697:	53                   	push   %ebx
80102698:	83 ec 04             	sub    $0x4,%esp
8010269b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
8010269e:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
801026a4:	75 7a                	jne    80102720 <kfree+0x90>
801026a6:	81 fb c8 55 11 80    	cmp    $0x801155c8,%ebx
801026ac:	72 72                	jb     80102720 <kfree+0x90>
801026ae:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801026b4:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
801026b9:	77 65                	ja     80102720 <kfree+0x90>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
801026bb:	83 ec 04             	sub    $0x4,%esp
801026be:	68 00 10 00 00       	push   $0x1000
801026c3:	6a 01                	push   $0x1
801026c5:	53                   	push   %ebx
801026c6:	e8 d5 21 00 00       	call   801048a0 <memset>

  if(kmem.use_lock)
801026cb:	8b 15 94 26 11 80    	mov    0x80112694,%edx
801026d1:	83 c4 10             	add    $0x10,%esp
801026d4:	85 d2                	test   %edx,%edx
801026d6:	75 20                	jne    801026f8 <kfree+0x68>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
801026d8:	a1 98 26 11 80       	mov    0x80112698,%eax
801026dd:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
801026df:	a1 94 26 11 80       	mov    0x80112694,%eax
  kmem.freelist = r;
801026e4:	89 1d 98 26 11 80    	mov    %ebx,0x80112698
  if(kmem.use_lock)
801026ea:	85 c0                	test   %eax,%eax
801026ec:	75 22                	jne    80102710 <kfree+0x80>
    release(&kmem.lock);
}
801026ee:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801026f1:	c9                   	leave  
801026f2:	c3                   	ret    
801026f3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801026f7:	90                   	nop
    acquire(&kmem.lock);
801026f8:	83 ec 0c             	sub    $0xc,%esp
801026fb:	68 60 26 11 80       	push   $0x80112660
80102700:	e8 8b 20 00 00       	call   80104790 <acquire>
80102705:	83 c4 10             	add    $0x10,%esp
80102708:	eb ce                	jmp    801026d8 <kfree+0x48>
8010270a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
80102710:	c7 45 08 60 26 11 80 	movl   $0x80112660,0x8(%ebp)
}
80102717:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010271a:	c9                   	leave  
    release(&kmem.lock);
8010271b:	e9 30 21 00 00       	jmp    80104850 <release>
    panic("kfree");
80102720:	83 ec 0c             	sub    $0xc,%esp
80102723:	68 e6 75 10 80       	push   $0x801075e6
80102728:	e8 63 dc ff ff       	call   80100390 <panic>
8010272d:	8d 76 00             	lea    0x0(%esi),%esi

80102730 <freerange>:
{
80102730:	f3 0f 1e fb          	endbr32 
80102734:	55                   	push   %ebp
80102735:	89 e5                	mov    %esp,%ebp
80102737:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
80102738:	8b 45 08             	mov    0x8(%ebp),%eax
{
8010273b:	8b 75 0c             	mov    0xc(%ebp),%esi
8010273e:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
8010273f:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102745:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010274b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102751:	39 de                	cmp    %ebx,%esi
80102753:	72 1f                	jb     80102774 <freerange+0x44>
80102755:	8d 76 00             	lea    0x0(%esi),%esi
    kfree(p);
80102758:	83 ec 0c             	sub    $0xc,%esp
8010275b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102761:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102767:	50                   	push   %eax
80102768:	e8 23 ff ff ff       	call   80102690 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010276d:	83 c4 10             	add    $0x10,%esp
80102770:	39 f3                	cmp    %esi,%ebx
80102772:	76 e4                	jbe    80102758 <freerange+0x28>
}
80102774:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102777:	5b                   	pop    %ebx
80102778:	5e                   	pop    %esi
80102779:	5d                   	pop    %ebp
8010277a:	c3                   	ret    
8010277b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010277f:	90                   	nop

80102780 <kinit1>:
{
80102780:	f3 0f 1e fb          	endbr32 
80102784:	55                   	push   %ebp
80102785:	89 e5                	mov    %esp,%ebp
80102787:	56                   	push   %esi
80102788:	53                   	push   %ebx
80102789:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
8010278c:	83 ec 08             	sub    $0x8,%esp
8010278f:	68 ec 75 10 80       	push   $0x801075ec
80102794:	68 60 26 11 80       	push   $0x80112660
80102799:	e8 72 1e 00 00       	call   80104610 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
8010279e:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801027a1:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
801027a4:	c7 05 94 26 11 80 00 	movl   $0x0,0x80112694
801027ab:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
801027ae:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801027b4:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801027ba:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801027c0:	39 de                	cmp    %ebx,%esi
801027c2:	72 20                	jb     801027e4 <kinit1+0x64>
801027c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
801027c8:	83 ec 0c             	sub    $0xc,%esp
801027cb:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801027d1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801027d7:	50                   	push   %eax
801027d8:	e8 b3 fe ff ff       	call   80102690 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801027dd:	83 c4 10             	add    $0x10,%esp
801027e0:	39 de                	cmp    %ebx,%esi
801027e2:	73 e4                	jae    801027c8 <kinit1+0x48>
}
801027e4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801027e7:	5b                   	pop    %ebx
801027e8:	5e                   	pop    %esi
801027e9:	5d                   	pop    %ebp
801027ea:	c3                   	ret    
801027eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801027ef:	90                   	nop

801027f0 <kinit2>:
{
801027f0:	f3 0f 1e fb          	endbr32 
801027f4:	55                   	push   %ebp
801027f5:	89 e5                	mov    %esp,%ebp
801027f7:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
801027f8:	8b 45 08             	mov    0x8(%ebp),%eax
{
801027fb:	8b 75 0c             	mov    0xc(%ebp),%esi
801027fe:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
801027ff:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102805:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010280b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102811:	39 de                	cmp    %ebx,%esi
80102813:	72 1f                	jb     80102834 <kinit2+0x44>
80102815:	8d 76 00             	lea    0x0(%esi),%esi
    kfree(p);
80102818:	83 ec 0c             	sub    $0xc,%esp
8010281b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102821:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102827:	50                   	push   %eax
80102828:	e8 63 fe ff ff       	call   80102690 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010282d:	83 c4 10             	add    $0x10,%esp
80102830:	39 de                	cmp    %ebx,%esi
80102832:	73 e4                	jae    80102818 <kinit2+0x28>
  kmem.use_lock = 1;
80102834:	c7 05 94 26 11 80 01 	movl   $0x1,0x80112694
8010283b:	00 00 00 
}
8010283e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102841:	5b                   	pop    %ebx
80102842:	5e                   	pop    %esi
80102843:	5d                   	pop    %ebp
80102844:	c3                   	ret    
80102845:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010284c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102850 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102850:	f3 0f 1e fb          	endbr32 
  struct run *r;

  if(kmem.use_lock)
80102854:	a1 94 26 11 80       	mov    0x80112694,%eax
80102859:	85 c0                	test   %eax,%eax
8010285b:	75 1b                	jne    80102878 <kalloc+0x28>
    acquire(&kmem.lock);
  r = kmem.freelist;
8010285d:	a1 98 26 11 80       	mov    0x80112698,%eax
  if(r)
80102862:	85 c0                	test   %eax,%eax
80102864:	74 0a                	je     80102870 <kalloc+0x20>
    kmem.freelist = r->next;
80102866:	8b 10                	mov    (%eax),%edx
80102868:	89 15 98 26 11 80    	mov    %edx,0x80112698
  if(kmem.use_lock)
8010286e:	c3                   	ret    
8010286f:	90                   	nop
    release(&kmem.lock);
  return (char*)r;
}
80102870:	c3                   	ret    
80102871:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
80102878:	55                   	push   %ebp
80102879:	89 e5                	mov    %esp,%ebp
8010287b:	83 ec 24             	sub    $0x24,%esp
    acquire(&kmem.lock);
8010287e:	68 60 26 11 80       	push   $0x80112660
80102883:	e8 08 1f 00 00       	call   80104790 <acquire>
  r = kmem.freelist;
80102888:	a1 98 26 11 80       	mov    0x80112698,%eax
  if(r)
8010288d:	8b 15 94 26 11 80    	mov    0x80112694,%edx
80102893:	83 c4 10             	add    $0x10,%esp
80102896:	85 c0                	test   %eax,%eax
80102898:	74 08                	je     801028a2 <kalloc+0x52>
    kmem.freelist = r->next;
8010289a:	8b 08                	mov    (%eax),%ecx
8010289c:	89 0d 98 26 11 80    	mov    %ecx,0x80112698
  if(kmem.use_lock)
801028a2:	85 d2                	test   %edx,%edx
801028a4:	74 16                	je     801028bc <kalloc+0x6c>
    release(&kmem.lock);
801028a6:	83 ec 0c             	sub    $0xc,%esp
801028a9:	89 45 f4             	mov    %eax,-0xc(%ebp)
801028ac:	68 60 26 11 80       	push   $0x80112660
801028b1:	e8 9a 1f 00 00       	call   80104850 <release>
  return (char*)r;
801028b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
801028b9:	83 c4 10             	add    $0x10,%esp
}
801028bc:	c9                   	leave  
801028bd:	c3                   	ret    
801028be:	66 90                	xchg   %ax,%ax

801028c0 <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
801028c0:	f3 0f 1e fb          	endbr32 
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028c4:	ba 64 00 00 00       	mov    $0x64,%edx
801028c9:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
801028ca:	a8 01                	test   $0x1,%al
801028cc:	0f 84 be 00 00 00    	je     80102990 <kbdgetc+0xd0>
{
801028d2:	55                   	push   %ebp
801028d3:	ba 60 00 00 00       	mov    $0x60,%edx
801028d8:	89 e5                	mov    %esp,%ebp
801028da:	53                   	push   %ebx
801028db:	ec                   	in     (%dx),%al
  return data;
801028dc:	8b 1d d4 a5 10 80    	mov    0x8010a5d4,%ebx
    return -1;
  data = inb(KBDATAP);
801028e2:	0f b6 d0             	movzbl %al,%edx

  if(data == 0xE0){
801028e5:	3c e0                	cmp    $0xe0,%al
801028e7:	74 57                	je     80102940 <kbdgetc+0x80>
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
801028e9:	89 d9                	mov    %ebx,%ecx
801028eb:	83 e1 40             	and    $0x40,%ecx
801028ee:	84 c0                	test   %al,%al
801028f0:	78 5e                	js     80102950 <kbdgetc+0x90>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
801028f2:	85 c9                	test   %ecx,%ecx
801028f4:	74 09                	je     801028ff <kbdgetc+0x3f>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
801028f6:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
801028f9:	83 e3 bf             	and    $0xffffffbf,%ebx
    data |= 0x80;
801028fc:	0f b6 d0             	movzbl %al,%edx
  }

  shift |= shiftcode[data];
801028ff:	0f b6 8a 20 77 10 80 	movzbl -0x7fef88e0(%edx),%ecx
  shift ^= togglecode[data];
80102906:	0f b6 82 20 76 10 80 	movzbl -0x7fef89e0(%edx),%eax
  shift |= shiftcode[data];
8010290d:	09 d9                	or     %ebx,%ecx
  shift ^= togglecode[data];
8010290f:	31 c1                	xor    %eax,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102911:	89 c8                	mov    %ecx,%eax
  shift ^= togglecode[data];
80102913:	89 0d d4 a5 10 80    	mov    %ecx,0x8010a5d4
  c = charcode[shift & (CTL | SHIFT)][data];
80102919:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
8010291c:	83 e1 08             	and    $0x8,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
8010291f:	8b 04 85 00 76 10 80 	mov    -0x7fef8a00(,%eax,4),%eax
80102926:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
8010292a:	74 0b                	je     80102937 <kbdgetc+0x77>
    if('a' <= c && c <= 'z')
8010292c:	8d 50 9f             	lea    -0x61(%eax),%edx
8010292f:	83 fa 19             	cmp    $0x19,%edx
80102932:	77 44                	ja     80102978 <kbdgetc+0xb8>
      c += 'A' - 'a';
80102934:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102937:	5b                   	pop    %ebx
80102938:	5d                   	pop    %ebp
80102939:	c3                   	ret    
8010293a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    shift |= E0ESC;
80102940:	83 cb 40             	or     $0x40,%ebx
    return 0;
80102943:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
80102945:	89 1d d4 a5 10 80    	mov    %ebx,0x8010a5d4
}
8010294b:	5b                   	pop    %ebx
8010294c:	5d                   	pop    %ebp
8010294d:	c3                   	ret    
8010294e:	66 90                	xchg   %ax,%ax
    data = (shift & E0ESC ? data : data & 0x7F);
80102950:	83 e0 7f             	and    $0x7f,%eax
80102953:	85 c9                	test   %ecx,%ecx
80102955:	0f 44 d0             	cmove  %eax,%edx
    return 0;
80102958:	31 c0                	xor    %eax,%eax
    shift &= ~(shiftcode[data] | E0ESC);
8010295a:	0f b6 8a 20 77 10 80 	movzbl -0x7fef88e0(%edx),%ecx
80102961:	83 c9 40             	or     $0x40,%ecx
80102964:	0f b6 c9             	movzbl %cl,%ecx
80102967:	f7 d1                	not    %ecx
80102969:	21 d9                	and    %ebx,%ecx
}
8010296b:	5b                   	pop    %ebx
8010296c:	5d                   	pop    %ebp
    shift &= ~(shiftcode[data] | E0ESC);
8010296d:	89 0d d4 a5 10 80    	mov    %ecx,0x8010a5d4
}
80102973:	c3                   	ret    
80102974:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    else if('A' <= c && c <= 'Z')
80102978:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
8010297b:	8d 50 20             	lea    0x20(%eax),%edx
}
8010297e:	5b                   	pop    %ebx
8010297f:	5d                   	pop    %ebp
      c += 'a' - 'A';
80102980:	83 f9 1a             	cmp    $0x1a,%ecx
80102983:	0f 42 c2             	cmovb  %edx,%eax
}
80102986:	c3                   	ret    
80102987:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010298e:	66 90                	xchg   %ax,%ax
    return -1;
80102990:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102995:	c3                   	ret    
80102996:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010299d:	8d 76 00             	lea    0x0(%esi),%esi

801029a0 <kbdintr>:

void
kbdintr(void)
{
801029a0:	f3 0f 1e fb          	endbr32 
801029a4:	55                   	push   %ebp
801029a5:	89 e5                	mov    %esp,%ebp
801029a7:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
801029aa:	68 c0 28 10 80       	push   $0x801028c0
801029af:	e8 0c e0 ff ff       	call   801009c0 <consoleintr>
}
801029b4:	83 c4 10             	add    $0x10,%esp
801029b7:	c9                   	leave  
801029b8:	c3                   	ret    
801029b9:	66 90                	xchg   %ax,%ax
801029bb:	66 90                	xchg   %ax,%ax
801029bd:	66 90                	xchg   %ax,%ax
801029bf:	90                   	nop

801029c0 <lapicinit>:
  lapic[ID];  // wait for write to finish, by reading
}

void
lapicinit(void)
{
801029c0:	f3 0f 1e fb          	endbr32 
  if(!lapic)
801029c4:	a1 9c 26 11 80       	mov    0x8011269c,%eax
801029c9:	85 c0                	test   %eax,%eax
801029cb:	0f 84 c7 00 00 00    	je     80102a98 <lapicinit+0xd8>
  lapic[index] = value;
801029d1:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
801029d8:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
801029db:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801029de:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
801029e5:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801029e8:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801029eb:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
801029f2:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
801029f5:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801029f8:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
801029ff:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
80102a02:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a05:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
80102a0c:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102a0f:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a12:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102a19:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102a1c:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
80102a1f:	8b 50 30             	mov    0x30(%eax),%edx
80102a22:	c1 ea 10             	shr    $0x10,%edx
80102a25:	81 e2 fc 00 00 00    	and    $0xfc,%edx
80102a2b:	75 73                	jne    80102aa0 <lapicinit+0xe0>
  lapic[index] = value;
80102a2d:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102a34:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a37:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a3a:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102a41:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a44:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a47:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102a4e:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a51:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a54:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102a5b:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a5e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a61:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102a68:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a6b:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a6e:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102a75:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102a78:	8b 50 20             	mov    0x20(%eax),%edx
80102a7b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102a7f:	90                   	nop
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102a80:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80102a86:	80 e6 10             	and    $0x10,%dh
80102a89:	75 f5                	jne    80102a80 <lapicinit+0xc0>
  lapic[index] = value;
80102a8b:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80102a92:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a95:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102a98:	c3                   	ret    
80102a99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  lapic[index] = value;
80102aa0:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80102aa7:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102aaa:	8b 50 20             	mov    0x20(%eax),%edx
}
80102aad:	e9 7b ff ff ff       	jmp    80102a2d <lapicinit+0x6d>
80102ab2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102ab9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102ac0 <lapicid>:

int
lapicid(void)
{
80102ac0:	f3 0f 1e fb          	endbr32 
  if (!lapic)
80102ac4:	a1 9c 26 11 80       	mov    0x8011269c,%eax
80102ac9:	85 c0                	test   %eax,%eax
80102acb:	74 0b                	je     80102ad8 <lapicid+0x18>
    return 0;
  return lapic[ID] >> 24;
80102acd:	8b 40 20             	mov    0x20(%eax),%eax
80102ad0:	c1 e8 18             	shr    $0x18,%eax
80102ad3:	c3                   	ret    
80102ad4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return 0;
80102ad8:	31 c0                	xor    %eax,%eax
}
80102ada:	c3                   	ret    
80102adb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102adf:	90                   	nop

80102ae0 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
80102ae0:	f3 0f 1e fb          	endbr32 
  if(lapic)
80102ae4:	a1 9c 26 11 80       	mov    0x8011269c,%eax
80102ae9:	85 c0                	test   %eax,%eax
80102aeb:	74 0d                	je     80102afa <lapiceoi+0x1a>
  lapic[index] = value;
80102aed:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102af4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102af7:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
80102afa:	c3                   	ret    
80102afb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102aff:	90                   	nop

80102b00 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80102b00:	f3 0f 1e fb          	endbr32 
}
80102b04:	c3                   	ret    
80102b05:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102b0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102b10 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102b10:	f3 0f 1e fb          	endbr32 
80102b14:	55                   	push   %ebp
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b15:	b8 0f 00 00 00       	mov    $0xf,%eax
80102b1a:	ba 70 00 00 00       	mov    $0x70,%edx
80102b1f:	89 e5                	mov    %esp,%ebp
80102b21:	53                   	push   %ebx
80102b22:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102b25:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102b28:	ee                   	out    %al,(%dx)
80102b29:	b8 0a 00 00 00       	mov    $0xa,%eax
80102b2e:	ba 71 00 00 00       	mov    $0x71,%edx
80102b33:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102b34:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102b36:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80102b39:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
80102b3f:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80102b41:	c1 e9 0c             	shr    $0xc,%ecx
  lapicw(ICRHI, apicid<<24);
80102b44:	89 da                	mov    %ebx,%edx
  wrv[1] = addr >> 4;
80102b46:	c1 e8 04             	shr    $0x4,%eax
    lapicw(ICRLO, STARTUP | (addr>>12));
80102b49:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
80102b4c:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
80102b52:	a1 9c 26 11 80       	mov    0x8011269c,%eax
80102b57:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102b5d:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102b60:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102b67:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102b6a:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102b6d:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102b74:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102b77:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102b7a:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102b80:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102b83:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102b89:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102b8c:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102b92:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102b95:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
    microdelay(200);
  }
}
80102b9b:	5b                   	pop    %ebx
  lapic[ID];  // wait for write to finish, by reading
80102b9c:	8b 40 20             	mov    0x20(%eax),%eax
}
80102b9f:	5d                   	pop    %ebp
80102ba0:	c3                   	ret    
80102ba1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102ba8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102baf:	90                   	nop

80102bb0 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
80102bb0:	f3 0f 1e fb          	endbr32 
80102bb4:	55                   	push   %ebp
80102bb5:	b8 0b 00 00 00       	mov    $0xb,%eax
80102bba:	ba 70 00 00 00       	mov    $0x70,%edx
80102bbf:	89 e5                	mov    %esp,%ebp
80102bc1:	57                   	push   %edi
80102bc2:	56                   	push   %esi
80102bc3:	53                   	push   %ebx
80102bc4:	83 ec 4c             	sub    $0x4c,%esp
80102bc7:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102bc8:	ba 71 00 00 00       	mov    $0x71,%edx
80102bcd:	ec                   	in     (%dx),%al
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
80102bce:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102bd1:	bb 70 00 00 00       	mov    $0x70,%ebx
80102bd6:	88 45 b3             	mov    %al,-0x4d(%ebp)
80102bd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102be0:	31 c0                	xor    %eax,%eax
80102be2:	89 da                	mov    %ebx,%edx
80102be4:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102be5:	b9 71 00 00 00       	mov    $0x71,%ecx
80102bea:	89 ca                	mov    %ecx,%edx
80102bec:	ec                   	in     (%dx),%al
80102bed:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102bf0:	89 da                	mov    %ebx,%edx
80102bf2:	b8 02 00 00 00       	mov    $0x2,%eax
80102bf7:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102bf8:	89 ca                	mov    %ecx,%edx
80102bfa:	ec                   	in     (%dx),%al
80102bfb:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102bfe:	89 da                	mov    %ebx,%edx
80102c00:	b8 04 00 00 00       	mov    $0x4,%eax
80102c05:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c06:	89 ca                	mov    %ecx,%edx
80102c08:	ec                   	in     (%dx),%al
80102c09:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c0c:	89 da                	mov    %ebx,%edx
80102c0e:	b8 07 00 00 00       	mov    $0x7,%eax
80102c13:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c14:	89 ca                	mov    %ecx,%edx
80102c16:	ec                   	in     (%dx),%al
80102c17:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c1a:	89 da                	mov    %ebx,%edx
80102c1c:	b8 08 00 00 00       	mov    $0x8,%eax
80102c21:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c22:	89 ca                	mov    %ecx,%edx
80102c24:	ec                   	in     (%dx),%al
80102c25:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c27:	89 da                	mov    %ebx,%edx
80102c29:	b8 09 00 00 00       	mov    $0x9,%eax
80102c2e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c2f:	89 ca                	mov    %ecx,%edx
80102c31:	ec                   	in     (%dx),%al
80102c32:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c34:	89 da                	mov    %ebx,%edx
80102c36:	b8 0a 00 00 00       	mov    $0xa,%eax
80102c3b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c3c:	89 ca                	mov    %ecx,%edx
80102c3e:	ec                   	in     (%dx),%al

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102c3f:	84 c0                	test   %al,%al
80102c41:	78 9d                	js     80102be0 <cmostime+0x30>
  return inb(CMOS_RETURN);
80102c43:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
80102c47:	89 fa                	mov    %edi,%edx
80102c49:	0f b6 fa             	movzbl %dl,%edi
80102c4c:	89 f2                	mov    %esi,%edx
80102c4e:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102c51:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80102c55:	0f b6 f2             	movzbl %dl,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c58:	89 da                	mov    %ebx,%edx
80102c5a:	89 7d c8             	mov    %edi,-0x38(%ebp)
80102c5d:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102c60:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
80102c64:	89 75 cc             	mov    %esi,-0x34(%ebp)
80102c67:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102c6a:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80102c6e:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102c71:	31 c0                	xor    %eax,%eax
80102c73:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c74:	89 ca                	mov    %ecx,%edx
80102c76:	ec                   	in     (%dx),%al
80102c77:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c7a:	89 da                	mov    %ebx,%edx
80102c7c:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102c7f:	b8 02 00 00 00       	mov    $0x2,%eax
80102c84:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c85:	89 ca                	mov    %ecx,%edx
80102c87:	ec                   	in     (%dx),%al
80102c88:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c8b:	89 da                	mov    %ebx,%edx
80102c8d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102c90:	b8 04 00 00 00       	mov    $0x4,%eax
80102c95:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c96:	89 ca                	mov    %ecx,%edx
80102c98:	ec                   	in     (%dx),%al
80102c99:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c9c:	89 da                	mov    %ebx,%edx
80102c9e:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102ca1:	b8 07 00 00 00       	mov    $0x7,%eax
80102ca6:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ca7:	89 ca                	mov    %ecx,%edx
80102ca9:	ec                   	in     (%dx),%al
80102caa:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102cad:	89 da                	mov    %ebx,%edx
80102caf:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102cb2:	b8 08 00 00 00       	mov    $0x8,%eax
80102cb7:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102cb8:	89 ca                	mov    %ecx,%edx
80102cba:	ec                   	in     (%dx),%al
80102cbb:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102cbe:	89 da                	mov    %ebx,%edx
80102cc0:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102cc3:	b8 09 00 00 00       	mov    $0x9,%eax
80102cc8:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102cc9:	89 ca                	mov    %ecx,%edx
80102ccb:	ec                   	in     (%dx),%al
80102ccc:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102ccf:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
80102cd2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102cd5:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102cd8:	6a 18                	push   $0x18
80102cda:	50                   	push   %eax
80102cdb:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102cde:	50                   	push   %eax
80102cdf:	e8 0c 1c 00 00       	call   801048f0 <memcmp>
80102ce4:	83 c4 10             	add    $0x10,%esp
80102ce7:	85 c0                	test   %eax,%eax
80102ce9:	0f 85 f1 fe ff ff    	jne    80102be0 <cmostime+0x30>
      break;
  }

  // convert
  if(bcd) {
80102cef:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
80102cf3:	75 78                	jne    80102d6d <cmostime+0x1bd>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102cf5:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102cf8:	89 c2                	mov    %eax,%edx
80102cfa:	83 e0 0f             	and    $0xf,%eax
80102cfd:	c1 ea 04             	shr    $0x4,%edx
80102d00:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102d03:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102d06:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102d09:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102d0c:	89 c2                	mov    %eax,%edx
80102d0e:	83 e0 0f             	and    $0xf,%eax
80102d11:	c1 ea 04             	shr    $0x4,%edx
80102d14:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102d17:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102d1a:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102d1d:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102d20:	89 c2                	mov    %eax,%edx
80102d22:	83 e0 0f             	and    $0xf,%eax
80102d25:	c1 ea 04             	shr    $0x4,%edx
80102d28:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102d2b:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102d2e:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102d31:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102d34:	89 c2                	mov    %eax,%edx
80102d36:	83 e0 0f             	and    $0xf,%eax
80102d39:	c1 ea 04             	shr    $0x4,%edx
80102d3c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102d3f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102d42:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80102d45:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102d48:	89 c2                	mov    %eax,%edx
80102d4a:	83 e0 0f             	and    $0xf,%eax
80102d4d:	c1 ea 04             	shr    $0x4,%edx
80102d50:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102d53:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102d56:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102d59:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102d5c:	89 c2                	mov    %eax,%edx
80102d5e:	83 e0 0f             	and    $0xf,%eax
80102d61:	c1 ea 04             	shr    $0x4,%edx
80102d64:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102d67:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102d6a:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102d6d:	8b 75 08             	mov    0x8(%ebp),%esi
80102d70:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102d73:	89 06                	mov    %eax,(%esi)
80102d75:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102d78:	89 46 04             	mov    %eax,0x4(%esi)
80102d7b:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102d7e:	89 46 08             	mov    %eax,0x8(%esi)
80102d81:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102d84:	89 46 0c             	mov    %eax,0xc(%esi)
80102d87:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102d8a:	89 46 10             	mov    %eax,0x10(%esi)
80102d8d:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102d90:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80102d93:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
80102d9a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102d9d:	5b                   	pop    %ebx
80102d9e:	5e                   	pop    %esi
80102d9f:	5f                   	pop    %edi
80102da0:	5d                   	pop    %ebp
80102da1:	c3                   	ret    
80102da2:	66 90                	xchg   %ax,%ax
80102da4:	66 90                	xchg   %ax,%ax
80102da6:	66 90                	xchg   %ax,%ax
80102da8:	66 90                	xchg   %ax,%ax
80102daa:	66 90                	xchg   %ax,%ax
80102dac:	66 90                	xchg   %ax,%ax
80102dae:	66 90                	xchg   %ax,%ax

80102db0 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102db0:	8b 0d e8 26 11 80    	mov    0x801126e8,%ecx
80102db6:	85 c9                	test   %ecx,%ecx
80102db8:	0f 8e 8a 00 00 00    	jle    80102e48 <install_trans+0x98>
{
80102dbe:	55                   	push   %ebp
80102dbf:	89 e5                	mov    %esp,%ebp
80102dc1:	57                   	push   %edi
  for (tail = 0; tail < log.lh.n; tail++) {
80102dc2:	31 ff                	xor    %edi,%edi
{
80102dc4:	56                   	push   %esi
80102dc5:	53                   	push   %ebx
80102dc6:	83 ec 0c             	sub    $0xc,%esp
80102dc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102dd0:	a1 d4 26 11 80       	mov    0x801126d4,%eax
80102dd5:	83 ec 08             	sub    $0x8,%esp
80102dd8:	01 f8                	add    %edi,%eax
80102dda:	83 c0 01             	add    $0x1,%eax
80102ddd:	50                   	push   %eax
80102dde:	ff 35 e4 26 11 80    	pushl  0x801126e4
80102de4:	e8 e7 d2 ff ff       	call   801000d0 <bread>
80102de9:	89 c6                	mov    %eax,%esi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102deb:	58                   	pop    %eax
80102dec:	5a                   	pop    %edx
80102ded:	ff 34 bd ec 26 11 80 	pushl  -0x7feed914(,%edi,4)
80102df4:	ff 35 e4 26 11 80    	pushl  0x801126e4
  for (tail = 0; tail < log.lh.n; tail++) {
80102dfa:	83 c7 01             	add    $0x1,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102dfd:	e8 ce d2 ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102e02:	83 c4 0c             	add    $0xc,%esp
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102e05:	89 c3                	mov    %eax,%ebx
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102e07:	8d 46 5c             	lea    0x5c(%esi),%eax
80102e0a:	68 00 02 00 00       	push   $0x200
80102e0f:	50                   	push   %eax
80102e10:	8d 43 5c             	lea    0x5c(%ebx),%eax
80102e13:	50                   	push   %eax
80102e14:	e8 27 1b 00 00       	call   80104940 <memmove>
    bwrite(dbuf);  // write dst to disk
80102e19:	89 1c 24             	mov    %ebx,(%esp)
80102e1c:	e8 8f d3 ff ff       	call   801001b0 <bwrite>
    brelse(lbuf);
80102e21:	89 34 24             	mov    %esi,(%esp)
80102e24:	e8 c7 d3 ff ff       	call   801001f0 <brelse>
    brelse(dbuf);
80102e29:	89 1c 24             	mov    %ebx,(%esp)
80102e2c:	e8 bf d3 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102e31:	83 c4 10             	add    $0x10,%esp
80102e34:	39 3d e8 26 11 80    	cmp    %edi,0x801126e8
80102e3a:	7f 94                	jg     80102dd0 <install_trans+0x20>
  }
}
80102e3c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102e3f:	5b                   	pop    %ebx
80102e40:	5e                   	pop    %esi
80102e41:	5f                   	pop    %edi
80102e42:	5d                   	pop    %ebp
80102e43:	c3                   	ret    
80102e44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102e48:	c3                   	ret    
80102e49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102e50 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102e50:	55                   	push   %ebp
80102e51:	89 e5                	mov    %esp,%ebp
80102e53:	53                   	push   %ebx
80102e54:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80102e57:	ff 35 d4 26 11 80    	pushl  0x801126d4
80102e5d:	ff 35 e4 26 11 80    	pushl  0x801126e4
80102e63:	e8 68 d2 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102e68:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80102e6b:	89 c3                	mov    %eax,%ebx
  hb->n = log.lh.n;
80102e6d:	a1 e8 26 11 80       	mov    0x801126e8,%eax
80102e72:	89 43 5c             	mov    %eax,0x5c(%ebx)
  for (i = 0; i < log.lh.n; i++) {
80102e75:	85 c0                	test   %eax,%eax
80102e77:	7e 19                	jle    80102e92 <write_head+0x42>
80102e79:	31 d2                	xor    %edx,%edx
80102e7b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102e7f:	90                   	nop
    hb->block[i] = log.lh.block[i];
80102e80:	8b 0c 95 ec 26 11 80 	mov    -0x7feed914(,%edx,4),%ecx
80102e87:	89 4c 93 60          	mov    %ecx,0x60(%ebx,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102e8b:	83 c2 01             	add    $0x1,%edx
80102e8e:	39 d0                	cmp    %edx,%eax
80102e90:	75 ee                	jne    80102e80 <write_head+0x30>
  }
  bwrite(buf);
80102e92:	83 ec 0c             	sub    $0xc,%esp
80102e95:	53                   	push   %ebx
80102e96:	e8 15 d3 ff ff       	call   801001b0 <bwrite>
  brelse(buf);
80102e9b:	89 1c 24             	mov    %ebx,(%esp)
80102e9e:	e8 4d d3 ff ff       	call   801001f0 <brelse>
}
80102ea3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102ea6:	83 c4 10             	add    $0x10,%esp
80102ea9:	c9                   	leave  
80102eaa:	c3                   	ret    
80102eab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102eaf:	90                   	nop

80102eb0 <initlog>:
{
80102eb0:	f3 0f 1e fb          	endbr32 
80102eb4:	55                   	push   %ebp
80102eb5:	89 e5                	mov    %esp,%ebp
80102eb7:	53                   	push   %ebx
80102eb8:	83 ec 2c             	sub    $0x2c,%esp
80102ebb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102ebe:	68 20 78 10 80       	push   $0x80107820
80102ec3:	68 a0 26 11 80       	push   $0x801126a0
80102ec8:	e8 43 17 00 00       	call   80104610 <initlock>
  readsb(dev, &sb);
80102ecd:	58                   	pop    %eax
80102ece:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102ed1:	5a                   	pop    %edx
80102ed2:	50                   	push   %eax
80102ed3:	53                   	push   %ebx
80102ed4:	e8 47 e8 ff ff       	call   80101720 <readsb>
  log.start = sb.logstart;
80102ed9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80102edc:	59                   	pop    %ecx
  log.dev = dev;
80102edd:	89 1d e4 26 11 80    	mov    %ebx,0x801126e4
  log.size = sb.nlog;
80102ee3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80102ee6:	a3 d4 26 11 80       	mov    %eax,0x801126d4
  log.size = sb.nlog;
80102eeb:	89 15 d8 26 11 80    	mov    %edx,0x801126d8
  struct buf *buf = bread(log.dev, log.start);
80102ef1:	5a                   	pop    %edx
80102ef2:	50                   	push   %eax
80102ef3:	53                   	push   %ebx
80102ef4:	e8 d7 d1 ff ff       	call   801000d0 <bread>
  for (i = 0; i < log.lh.n; i++) {
80102ef9:	83 c4 10             	add    $0x10,%esp
  log.lh.n = lh->n;
80102efc:	8b 48 5c             	mov    0x5c(%eax),%ecx
80102eff:	89 0d e8 26 11 80    	mov    %ecx,0x801126e8
  for (i = 0; i < log.lh.n; i++) {
80102f05:	85 c9                	test   %ecx,%ecx
80102f07:	7e 19                	jle    80102f22 <initlog+0x72>
80102f09:	31 d2                	xor    %edx,%edx
80102f0b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102f0f:	90                   	nop
    log.lh.block[i] = lh->block[i];
80102f10:	8b 5c 90 60          	mov    0x60(%eax,%edx,4),%ebx
80102f14:	89 1c 95 ec 26 11 80 	mov    %ebx,-0x7feed914(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102f1b:	83 c2 01             	add    $0x1,%edx
80102f1e:	39 d1                	cmp    %edx,%ecx
80102f20:	75 ee                	jne    80102f10 <initlog+0x60>
  brelse(buf);
80102f22:	83 ec 0c             	sub    $0xc,%esp
80102f25:	50                   	push   %eax
80102f26:	e8 c5 d2 ff ff       	call   801001f0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102f2b:	e8 80 fe ff ff       	call   80102db0 <install_trans>
  log.lh.n = 0;
80102f30:	c7 05 e8 26 11 80 00 	movl   $0x0,0x801126e8
80102f37:	00 00 00 
  write_head(); // clear the log
80102f3a:	e8 11 ff ff ff       	call   80102e50 <write_head>
}
80102f3f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102f42:	83 c4 10             	add    $0x10,%esp
80102f45:	c9                   	leave  
80102f46:	c3                   	ret    
80102f47:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102f4e:	66 90                	xchg   %ax,%ax

80102f50 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102f50:	f3 0f 1e fb          	endbr32 
80102f54:	55                   	push   %ebp
80102f55:	89 e5                	mov    %esp,%ebp
80102f57:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102f5a:	68 a0 26 11 80       	push   $0x801126a0
80102f5f:	e8 2c 18 00 00       	call   80104790 <acquire>
80102f64:	83 c4 10             	add    $0x10,%esp
80102f67:	eb 1c                	jmp    80102f85 <begin_op+0x35>
80102f69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102f70:	83 ec 08             	sub    $0x8,%esp
80102f73:	68 a0 26 11 80       	push   $0x801126a0
80102f78:	68 a0 26 11 80       	push   $0x801126a0
80102f7d:	e8 ce 11 00 00       	call   80104150 <sleep>
80102f82:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80102f85:	a1 e0 26 11 80       	mov    0x801126e0,%eax
80102f8a:	85 c0                	test   %eax,%eax
80102f8c:	75 e2                	jne    80102f70 <begin_op+0x20>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102f8e:	a1 dc 26 11 80       	mov    0x801126dc,%eax
80102f93:	8b 15 e8 26 11 80    	mov    0x801126e8,%edx
80102f99:	83 c0 01             	add    $0x1,%eax
80102f9c:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102f9f:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102fa2:	83 fa 1e             	cmp    $0x1e,%edx
80102fa5:	7f c9                	jg     80102f70 <begin_op+0x20>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102fa7:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80102faa:	a3 dc 26 11 80       	mov    %eax,0x801126dc
      release(&log.lock);
80102faf:	68 a0 26 11 80       	push   $0x801126a0
80102fb4:	e8 97 18 00 00       	call   80104850 <release>
      break;
    }
  }
}
80102fb9:	83 c4 10             	add    $0x10,%esp
80102fbc:	c9                   	leave  
80102fbd:	c3                   	ret    
80102fbe:	66 90                	xchg   %ax,%ax

80102fc0 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102fc0:	f3 0f 1e fb          	endbr32 
80102fc4:	55                   	push   %ebp
80102fc5:	89 e5                	mov    %esp,%ebp
80102fc7:	57                   	push   %edi
80102fc8:	56                   	push   %esi
80102fc9:	53                   	push   %ebx
80102fca:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102fcd:	68 a0 26 11 80       	push   $0x801126a0
80102fd2:	e8 b9 17 00 00       	call   80104790 <acquire>
  log.outstanding -= 1;
80102fd7:	a1 dc 26 11 80       	mov    0x801126dc,%eax
  if(log.committing)
80102fdc:	8b 35 e0 26 11 80    	mov    0x801126e0,%esi
80102fe2:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80102fe5:	8d 58 ff             	lea    -0x1(%eax),%ebx
80102fe8:	89 1d dc 26 11 80    	mov    %ebx,0x801126dc
  if(log.committing)
80102fee:	85 f6                	test   %esi,%esi
80102ff0:	0f 85 1e 01 00 00    	jne    80103114 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
80102ff6:	85 db                	test   %ebx,%ebx
80102ff8:	0f 85 f2 00 00 00    	jne    801030f0 <end_op+0x130>
    do_commit = 1;
    log.committing = 1;
80102ffe:	c7 05 e0 26 11 80 01 	movl   $0x1,0x801126e0
80103005:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80103008:	83 ec 0c             	sub    $0xc,%esp
8010300b:	68 a0 26 11 80       	push   $0x801126a0
80103010:	e8 3b 18 00 00       	call   80104850 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80103015:	8b 0d e8 26 11 80    	mov    0x801126e8,%ecx
8010301b:	83 c4 10             	add    $0x10,%esp
8010301e:	85 c9                	test   %ecx,%ecx
80103020:	7f 3e                	jg     80103060 <end_op+0xa0>
    acquire(&log.lock);
80103022:	83 ec 0c             	sub    $0xc,%esp
80103025:	68 a0 26 11 80       	push   $0x801126a0
8010302a:	e8 61 17 00 00       	call   80104790 <acquire>
    wakeup(&log);
8010302f:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
    log.committing = 0;
80103036:	c7 05 e0 26 11 80 00 	movl   $0x0,0x801126e0
8010303d:	00 00 00 
    wakeup(&log);
80103040:	e8 cb 12 00 00       	call   80104310 <wakeup>
    release(&log.lock);
80103045:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
8010304c:	e8 ff 17 00 00       	call   80104850 <release>
80103051:	83 c4 10             	add    $0x10,%esp
}
80103054:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103057:	5b                   	pop    %ebx
80103058:	5e                   	pop    %esi
80103059:	5f                   	pop    %edi
8010305a:	5d                   	pop    %ebp
8010305b:	c3                   	ret    
8010305c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80103060:	a1 d4 26 11 80       	mov    0x801126d4,%eax
80103065:	83 ec 08             	sub    $0x8,%esp
80103068:	01 d8                	add    %ebx,%eax
8010306a:	83 c0 01             	add    $0x1,%eax
8010306d:	50                   	push   %eax
8010306e:	ff 35 e4 26 11 80    	pushl  0x801126e4
80103074:	e8 57 d0 ff ff       	call   801000d0 <bread>
80103079:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
8010307b:	58                   	pop    %eax
8010307c:	5a                   	pop    %edx
8010307d:	ff 34 9d ec 26 11 80 	pushl  -0x7feed914(,%ebx,4)
80103084:	ff 35 e4 26 11 80    	pushl  0x801126e4
  for (tail = 0; tail < log.lh.n; tail++) {
8010308a:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
8010308d:	e8 3e d0 ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
80103092:	83 c4 0c             	add    $0xc,%esp
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80103095:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80103097:	8d 40 5c             	lea    0x5c(%eax),%eax
8010309a:	68 00 02 00 00       	push   $0x200
8010309f:	50                   	push   %eax
801030a0:	8d 46 5c             	lea    0x5c(%esi),%eax
801030a3:	50                   	push   %eax
801030a4:	e8 97 18 00 00       	call   80104940 <memmove>
    bwrite(to);  // write the log
801030a9:	89 34 24             	mov    %esi,(%esp)
801030ac:	e8 ff d0 ff ff       	call   801001b0 <bwrite>
    brelse(from);
801030b1:	89 3c 24             	mov    %edi,(%esp)
801030b4:	e8 37 d1 ff ff       	call   801001f0 <brelse>
    brelse(to);
801030b9:	89 34 24             	mov    %esi,(%esp)
801030bc:	e8 2f d1 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
801030c1:	83 c4 10             	add    $0x10,%esp
801030c4:	3b 1d e8 26 11 80    	cmp    0x801126e8,%ebx
801030ca:	7c 94                	jl     80103060 <end_op+0xa0>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
801030cc:	e8 7f fd ff ff       	call   80102e50 <write_head>
    install_trans(); // Now install writes to home locations
801030d1:	e8 da fc ff ff       	call   80102db0 <install_trans>
    log.lh.n = 0;
801030d6:	c7 05 e8 26 11 80 00 	movl   $0x0,0x801126e8
801030dd:	00 00 00 
    write_head();    // Erase the transaction from the log
801030e0:	e8 6b fd ff ff       	call   80102e50 <write_head>
801030e5:	e9 38 ff ff ff       	jmp    80103022 <end_op+0x62>
801030ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&log);
801030f0:	83 ec 0c             	sub    $0xc,%esp
801030f3:	68 a0 26 11 80       	push   $0x801126a0
801030f8:	e8 13 12 00 00       	call   80104310 <wakeup>
  release(&log.lock);
801030fd:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
80103104:	e8 47 17 00 00       	call   80104850 <release>
80103109:	83 c4 10             	add    $0x10,%esp
}
8010310c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010310f:	5b                   	pop    %ebx
80103110:	5e                   	pop    %esi
80103111:	5f                   	pop    %edi
80103112:	5d                   	pop    %ebp
80103113:	c3                   	ret    
    panic("log.committing");
80103114:	83 ec 0c             	sub    $0xc,%esp
80103117:	68 24 78 10 80       	push   $0x80107824
8010311c:	e8 6f d2 ff ff       	call   80100390 <panic>
80103121:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103128:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010312f:	90                   	nop

80103130 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80103130:	f3 0f 1e fb          	endbr32 
80103134:	55                   	push   %ebp
80103135:	89 e5                	mov    %esp,%ebp
80103137:	53                   	push   %ebx
80103138:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
8010313b:	8b 15 e8 26 11 80    	mov    0x801126e8,%edx
{
80103141:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103144:	83 fa 1d             	cmp    $0x1d,%edx
80103147:	0f 8f 91 00 00 00    	jg     801031de <log_write+0xae>
8010314d:	a1 d8 26 11 80       	mov    0x801126d8,%eax
80103152:	83 e8 01             	sub    $0x1,%eax
80103155:	39 c2                	cmp    %eax,%edx
80103157:	0f 8d 81 00 00 00    	jge    801031de <log_write+0xae>
    panic("too big a transaction");
  if (log.outstanding < 1)
8010315d:	a1 dc 26 11 80       	mov    0x801126dc,%eax
80103162:	85 c0                	test   %eax,%eax
80103164:	0f 8e 81 00 00 00    	jle    801031eb <log_write+0xbb>
    panic("log_write outside of trans");

  acquire(&log.lock);
8010316a:	83 ec 0c             	sub    $0xc,%esp
8010316d:	68 a0 26 11 80       	push   $0x801126a0
80103172:	e8 19 16 00 00       	call   80104790 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80103177:	8b 15 e8 26 11 80    	mov    0x801126e8,%edx
8010317d:	83 c4 10             	add    $0x10,%esp
80103180:	85 d2                	test   %edx,%edx
80103182:	7e 4e                	jle    801031d2 <log_write+0xa2>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103184:	8b 4b 08             	mov    0x8(%ebx),%ecx
  for (i = 0; i < log.lh.n; i++) {
80103187:	31 c0                	xor    %eax,%eax
80103189:	eb 0c                	jmp    80103197 <log_write+0x67>
8010318b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010318f:	90                   	nop
80103190:	83 c0 01             	add    $0x1,%eax
80103193:	39 c2                	cmp    %eax,%edx
80103195:	74 29                	je     801031c0 <log_write+0x90>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103197:	39 0c 85 ec 26 11 80 	cmp    %ecx,-0x7feed914(,%eax,4)
8010319e:	75 f0                	jne    80103190 <log_write+0x60>
      break;
  }
  log.lh.block[i] = b->blockno;
801031a0:	89 0c 85 ec 26 11 80 	mov    %ecx,-0x7feed914(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
801031a7:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
}
801031aa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  release(&log.lock);
801031ad:	c7 45 08 a0 26 11 80 	movl   $0x801126a0,0x8(%ebp)
}
801031b4:	c9                   	leave  
  release(&log.lock);
801031b5:	e9 96 16 00 00       	jmp    80104850 <release>
801031ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
801031c0:	89 0c 95 ec 26 11 80 	mov    %ecx,-0x7feed914(,%edx,4)
    log.lh.n++;
801031c7:	83 c2 01             	add    $0x1,%edx
801031ca:	89 15 e8 26 11 80    	mov    %edx,0x801126e8
801031d0:	eb d5                	jmp    801031a7 <log_write+0x77>
  log.lh.block[i] = b->blockno;
801031d2:	8b 43 08             	mov    0x8(%ebx),%eax
801031d5:	a3 ec 26 11 80       	mov    %eax,0x801126ec
  if (i == log.lh.n)
801031da:	75 cb                	jne    801031a7 <log_write+0x77>
801031dc:	eb e9                	jmp    801031c7 <log_write+0x97>
    panic("too big a transaction");
801031de:	83 ec 0c             	sub    $0xc,%esp
801031e1:	68 33 78 10 80       	push   $0x80107833
801031e6:	e8 a5 d1 ff ff       	call   80100390 <panic>
    panic("log_write outside of trans");
801031eb:	83 ec 0c             	sub    $0xc,%esp
801031ee:	68 49 78 10 80       	push   $0x80107849
801031f3:	e8 98 d1 ff ff       	call   80100390 <panic>
801031f8:	66 90                	xchg   %ax,%ax
801031fa:	66 90                	xchg   %ax,%ax
801031fc:	66 90                	xchg   %ax,%ax
801031fe:	66 90                	xchg   %ax,%ax

80103200 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80103200:	55                   	push   %ebp
80103201:	89 e5                	mov    %esp,%ebp
80103203:	53                   	push   %ebx
80103204:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80103207:	e8 64 09 00 00       	call   80103b70 <cpuid>
8010320c:	89 c3                	mov    %eax,%ebx
8010320e:	e8 5d 09 00 00       	call   80103b70 <cpuid>
80103213:	83 ec 04             	sub    $0x4,%esp
80103216:	53                   	push   %ebx
80103217:	50                   	push   %eax
80103218:	68 64 78 10 80       	push   $0x80107864
8010321d:	e8 fe d4 ff ff       	call   80100720 <cprintf>
  idtinit();       // load idt register
80103222:	e8 89 29 00 00       	call   80105bb0 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80103227:	e8 d4 08 00 00       	call   80103b00 <mycpu>
8010322c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
8010322e:	b8 01 00 00 00       	mov    $0x1,%eax
80103233:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
8010323a:	e8 21 0c 00 00       	call   80103e60 <scheduler>
8010323f:	90                   	nop

80103240 <mpenter>:
{
80103240:	f3 0f 1e fb          	endbr32 
80103244:	55                   	push   %ebp
80103245:	89 e5                	mov    %esp,%ebp
80103247:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
8010324a:	e8 31 3a 00 00       	call   80106c80 <switchkvm>
  seginit();
8010324f:	e8 9c 39 00 00       	call   80106bf0 <seginit>
  lapicinit();
80103254:	e8 67 f7 ff ff       	call   801029c0 <lapicinit>
  mpmain();
80103259:	e8 a2 ff ff ff       	call   80103200 <mpmain>
8010325e:	66 90                	xchg   %ax,%ax

80103260 <main>:
{
80103260:	f3 0f 1e fb          	endbr32 
80103264:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80103268:	83 e4 f0             	and    $0xfffffff0,%esp
8010326b:	ff 71 fc             	pushl  -0x4(%ecx)
8010326e:	55                   	push   %ebp
8010326f:	89 e5                	mov    %esp,%ebp
80103271:	53                   	push   %ebx
80103272:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80103273:	83 ec 08             	sub    $0x8,%esp
80103276:	68 00 00 40 80       	push   $0x80400000
8010327b:	68 c8 55 11 80       	push   $0x801155c8
80103280:	e8 fb f4 ff ff       	call   80102780 <kinit1>
  kvmalloc();      // kernel page table
80103285:	e8 d6 3e 00 00       	call   80107160 <kvmalloc>
  mpinit();        // detect other processors
8010328a:	e8 81 01 00 00       	call   80103410 <mpinit>
  lapicinit();     // interrupt controller
8010328f:	e8 2c f7 ff ff       	call   801029c0 <lapicinit>
  seginit();       // segment descriptors
80103294:	e8 57 39 00 00       	call   80106bf0 <seginit>
  picinit();       // disable pic
80103299:	e8 52 03 00 00       	call   801035f0 <picinit>
  ioapicinit();    // another interrupt controller
8010329e:	e8 fd f2 ff ff       	call   801025a0 <ioapicinit>
  consoleinit();   // console hardware
801032a3:	e8 a8 d9 ff ff       	call   80100c50 <consoleinit>
  uartinit();      // serial port
801032a8:	e8 03 2c 00 00       	call   80105eb0 <uartinit>
  pinit();         // process table
801032ad:	e8 2e 08 00 00       	call   80103ae0 <pinit>
  tvinit();        // trap vectors
801032b2:	e8 79 28 00 00       	call   80105b30 <tvinit>
  binit();         // buffer cache
801032b7:	e8 84 cd ff ff       	call   80100040 <binit>
  fileinit();      // file table
801032bc:	e8 3f dd ff ff       	call   80101000 <fileinit>
  ideinit();       // disk 
801032c1:	e8 aa f0 ff ff       	call   80102370 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
801032c6:	83 c4 0c             	add    $0xc,%esp
801032c9:	68 8a 00 00 00       	push   $0x8a
801032ce:	68 8c a4 10 80       	push   $0x8010a48c
801032d3:	68 00 70 00 80       	push   $0x80007000
801032d8:	e8 63 16 00 00       	call   80104940 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
801032dd:	83 c4 10             	add    $0x10,%esp
801032e0:	69 05 20 2d 11 80 b0 	imul   $0xb0,0x80112d20,%eax
801032e7:	00 00 00 
801032ea:	05 a0 27 11 80       	add    $0x801127a0,%eax
801032ef:	3d a0 27 11 80       	cmp    $0x801127a0,%eax
801032f4:	76 7a                	jbe    80103370 <main+0x110>
801032f6:	bb a0 27 11 80       	mov    $0x801127a0,%ebx
801032fb:	eb 1c                	jmp    80103319 <main+0xb9>
801032fd:	8d 76 00             	lea    0x0(%esi),%esi
80103300:	69 05 20 2d 11 80 b0 	imul   $0xb0,0x80112d20,%eax
80103307:	00 00 00 
8010330a:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80103310:	05 a0 27 11 80       	add    $0x801127a0,%eax
80103315:	39 c3                	cmp    %eax,%ebx
80103317:	73 57                	jae    80103370 <main+0x110>
    if(c == mycpu())  // We've started already.
80103319:	e8 e2 07 00 00       	call   80103b00 <mycpu>
8010331e:	39 c3                	cmp    %eax,%ebx
80103320:	74 de                	je     80103300 <main+0xa0>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103322:	e8 29 f5 ff ff       	call   80102850 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void(**)(void))(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
80103327:	83 ec 08             	sub    $0x8,%esp
    *(void(**)(void))(code-8) = mpenter;
8010332a:	c7 05 f8 6f 00 80 40 	movl   $0x80103240,0x80006ff8
80103331:	32 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80103334:	c7 05 f4 6f 00 80 00 	movl   $0x109000,0x80006ff4
8010333b:	90 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
8010333e:	05 00 10 00 00       	add    $0x1000,%eax
80103343:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    lapicstartap(c->apicid, V2P(code));
80103348:	0f b6 03             	movzbl (%ebx),%eax
8010334b:	68 00 70 00 00       	push   $0x7000
80103350:	50                   	push   %eax
80103351:	e8 ba f7 ff ff       	call   80102b10 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103356:	83 c4 10             	add    $0x10,%esp
80103359:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103360:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80103366:	85 c0                	test   %eax,%eax
80103368:	74 f6                	je     80103360 <main+0x100>
8010336a:	eb 94                	jmp    80103300 <main+0xa0>
8010336c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103370:	83 ec 08             	sub    $0x8,%esp
80103373:	68 00 00 00 8e       	push   $0x8e000000
80103378:	68 00 00 40 80       	push   $0x80400000
8010337d:	e8 6e f4 ff ff       	call   801027f0 <kinit2>
  userinit();      // first user process
80103382:	e8 39 08 00 00       	call   80103bc0 <userinit>
  mpmain();        // finish this processor's setup
80103387:	e8 74 fe ff ff       	call   80103200 <mpmain>
8010338c:	66 90                	xchg   %ax,%ax
8010338e:	66 90                	xchg   %ax,%ax

80103390 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103390:	55                   	push   %ebp
80103391:	89 e5                	mov    %esp,%ebp
80103393:	57                   	push   %edi
80103394:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80103395:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
8010339b:	53                   	push   %ebx
  e = addr+len;
8010339c:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
8010339f:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
801033a2:	39 de                	cmp    %ebx,%esi
801033a4:	72 10                	jb     801033b6 <mpsearch1+0x26>
801033a6:	eb 50                	jmp    801033f8 <mpsearch1+0x68>
801033a8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801033af:	90                   	nop
801033b0:	89 fe                	mov    %edi,%esi
801033b2:	39 fb                	cmp    %edi,%ebx
801033b4:	76 42                	jbe    801033f8 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801033b6:	83 ec 04             	sub    $0x4,%esp
801033b9:	8d 7e 10             	lea    0x10(%esi),%edi
801033bc:	6a 04                	push   $0x4
801033be:	68 78 78 10 80       	push   $0x80107878
801033c3:	56                   	push   %esi
801033c4:	e8 27 15 00 00       	call   801048f0 <memcmp>
801033c9:	83 c4 10             	add    $0x10,%esp
801033cc:	85 c0                	test   %eax,%eax
801033ce:	75 e0                	jne    801033b0 <mpsearch1+0x20>
801033d0:	89 f2                	mov    %esi,%edx
801033d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
801033d8:	0f b6 0a             	movzbl (%edx),%ecx
801033db:	83 c2 01             	add    $0x1,%edx
801033de:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
801033e0:	39 fa                	cmp    %edi,%edx
801033e2:	75 f4                	jne    801033d8 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801033e4:	84 c0                	test   %al,%al
801033e6:	75 c8                	jne    801033b0 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
801033e8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801033eb:	89 f0                	mov    %esi,%eax
801033ed:	5b                   	pop    %ebx
801033ee:	5e                   	pop    %esi
801033ef:	5f                   	pop    %edi
801033f0:	5d                   	pop    %ebp
801033f1:	c3                   	ret    
801033f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801033f8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801033fb:	31 f6                	xor    %esi,%esi
}
801033fd:	5b                   	pop    %ebx
801033fe:	89 f0                	mov    %esi,%eax
80103400:	5e                   	pop    %esi
80103401:	5f                   	pop    %edi
80103402:	5d                   	pop    %ebp
80103403:	c3                   	ret    
80103404:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010340b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010340f:	90                   	nop

80103410 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80103410:	f3 0f 1e fb          	endbr32 
80103414:	55                   	push   %ebp
80103415:	89 e5                	mov    %esp,%ebp
80103417:	57                   	push   %edi
80103418:	56                   	push   %esi
80103419:	53                   	push   %ebx
8010341a:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
8010341d:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103424:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
8010342b:	c1 e0 08             	shl    $0x8,%eax
8010342e:	09 d0                	or     %edx,%eax
80103430:	c1 e0 04             	shl    $0x4,%eax
80103433:	75 1b                	jne    80103450 <mpinit+0x40>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103435:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
8010343c:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80103443:	c1 e0 08             	shl    $0x8,%eax
80103446:	09 d0                	or     %edx,%eax
80103448:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
8010344b:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
80103450:	ba 00 04 00 00       	mov    $0x400,%edx
80103455:	e8 36 ff ff ff       	call   80103390 <mpsearch1>
8010345a:	89 c6                	mov    %eax,%esi
8010345c:	85 c0                	test   %eax,%eax
8010345e:	0f 84 4c 01 00 00    	je     801035b0 <mpinit+0x1a0>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103464:	8b 5e 04             	mov    0x4(%esi),%ebx
80103467:	85 db                	test   %ebx,%ebx
80103469:	0f 84 61 01 00 00    	je     801035d0 <mpinit+0x1c0>
  if(memcmp(conf, "PCMP", 4) != 0)
8010346f:	83 ec 04             	sub    $0x4,%esp
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103472:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
  if(memcmp(conf, "PCMP", 4) != 0)
80103478:	6a 04                	push   $0x4
8010347a:	68 7d 78 10 80       	push   $0x8010787d
8010347f:	50                   	push   %eax
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103480:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
80103483:	e8 68 14 00 00       	call   801048f0 <memcmp>
80103488:	83 c4 10             	add    $0x10,%esp
8010348b:	85 c0                	test   %eax,%eax
8010348d:	0f 85 3d 01 00 00    	jne    801035d0 <mpinit+0x1c0>
  if(conf->version != 1 && conf->version != 4)
80103493:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
8010349a:	3c 01                	cmp    $0x1,%al
8010349c:	74 08                	je     801034a6 <mpinit+0x96>
8010349e:	3c 04                	cmp    $0x4,%al
801034a0:	0f 85 2a 01 00 00    	jne    801035d0 <mpinit+0x1c0>
  if(sum((uchar*)conf, conf->length) != 0)
801034a6:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
  for(i=0; i<len; i++)
801034ad:	66 85 d2             	test   %dx,%dx
801034b0:	74 26                	je     801034d8 <mpinit+0xc8>
801034b2:	8d 3c 1a             	lea    (%edx,%ebx,1),%edi
801034b5:	89 d8                	mov    %ebx,%eax
  sum = 0;
801034b7:	31 d2                	xor    %edx,%edx
801034b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sum += addr[i];
801034c0:	0f b6 88 00 00 00 80 	movzbl -0x80000000(%eax),%ecx
801034c7:	83 c0 01             	add    $0x1,%eax
801034ca:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
801034cc:	39 f8                	cmp    %edi,%eax
801034ce:	75 f0                	jne    801034c0 <mpinit+0xb0>
  if(sum((uchar*)conf, conf->length) != 0)
801034d0:	84 d2                	test   %dl,%dl
801034d2:	0f 85 f8 00 00 00    	jne    801035d0 <mpinit+0x1c0>
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
801034d8:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
801034de:	a3 9c 26 11 80       	mov    %eax,0x8011269c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801034e3:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
801034e9:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
  ismp = 1;
801034f0:	bb 01 00 00 00       	mov    $0x1,%ebx
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801034f5:	03 55 e4             	add    -0x1c(%ebp),%edx
801034f8:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
801034fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801034ff:	90                   	nop
80103500:	39 c2                	cmp    %eax,%edx
80103502:	76 15                	jbe    80103519 <mpinit+0x109>
    switch(*p){
80103504:	0f b6 08             	movzbl (%eax),%ecx
80103507:	80 f9 02             	cmp    $0x2,%cl
8010350a:	74 5c                	je     80103568 <mpinit+0x158>
8010350c:	77 42                	ja     80103550 <mpinit+0x140>
8010350e:	84 c9                	test   %cl,%cl
80103510:	74 6e                	je     80103580 <mpinit+0x170>
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103512:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103515:	39 c2                	cmp    %eax,%edx
80103517:	77 eb                	ja     80103504 <mpinit+0xf4>
80103519:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
8010351c:	85 db                	test   %ebx,%ebx
8010351e:	0f 84 b9 00 00 00    	je     801035dd <mpinit+0x1cd>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
80103524:	80 7e 0c 00          	cmpb   $0x0,0xc(%esi)
80103528:	74 15                	je     8010353f <mpinit+0x12f>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010352a:	b8 70 00 00 00       	mov    $0x70,%eax
8010352f:	ba 22 00 00 00       	mov    $0x22,%edx
80103534:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103535:	ba 23 00 00 00       	mov    $0x23,%edx
8010353a:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
8010353b:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010353e:	ee                   	out    %al,(%dx)
  }
}
8010353f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103542:	5b                   	pop    %ebx
80103543:	5e                   	pop    %esi
80103544:	5f                   	pop    %edi
80103545:	5d                   	pop    %ebp
80103546:	c3                   	ret    
80103547:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010354e:	66 90                	xchg   %ax,%ax
    switch(*p){
80103550:	83 e9 03             	sub    $0x3,%ecx
80103553:	80 f9 01             	cmp    $0x1,%cl
80103556:	76 ba                	jbe    80103512 <mpinit+0x102>
80103558:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
8010355f:	eb 9f                	jmp    80103500 <mpinit+0xf0>
80103561:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
80103568:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
      p += sizeof(struct mpioapic);
8010356c:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
8010356f:	88 0d 80 27 11 80    	mov    %cl,0x80112780
      continue;
80103575:	eb 89                	jmp    80103500 <mpinit+0xf0>
80103577:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010357e:	66 90                	xchg   %ax,%ax
      if(ncpu < NCPU) {
80103580:	8b 0d 20 2d 11 80    	mov    0x80112d20,%ecx
80103586:	83 f9 07             	cmp    $0x7,%ecx
80103589:	7f 19                	jg     801035a4 <mpinit+0x194>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010358b:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
80103591:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
        ncpu++;
80103595:	83 c1 01             	add    $0x1,%ecx
80103598:	89 0d 20 2d 11 80    	mov    %ecx,0x80112d20
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010359e:	88 9f a0 27 11 80    	mov    %bl,-0x7feed860(%edi)
      p += sizeof(struct mpproc);
801035a4:	83 c0 14             	add    $0x14,%eax
      continue;
801035a7:	e9 54 ff ff ff       	jmp    80103500 <mpinit+0xf0>
801035ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return mpsearch1(0xF0000, 0x10000);
801035b0:	ba 00 00 01 00       	mov    $0x10000,%edx
801035b5:	b8 00 00 0f 00       	mov    $0xf0000,%eax
801035ba:	e8 d1 fd ff ff       	call   80103390 <mpsearch1>
801035bf:	89 c6                	mov    %eax,%esi
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801035c1:	85 c0                	test   %eax,%eax
801035c3:	0f 85 9b fe ff ff    	jne    80103464 <mpinit+0x54>
801035c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    panic("Expect to run on an SMP");
801035d0:	83 ec 0c             	sub    $0xc,%esp
801035d3:	68 82 78 10 80       	push   $0x80107882
801035d8:	e8 b3 cd ff ff       	call   80100390 <panic>
    panic("Didn't find a suitable machine");
801035dd:	83 ec 0c             	sub    $0xc,%esp
801035e0:	68 9c 78 10 80       	push   $0x8010789c
801035e5:	e8 a6 cd ff ff       	call   80100390 <panic>
801035ea:	66 90                	xchg   %ax,%ax
801035ec:	66 90                	xchg   %ax,%ax
801035ee:	66 90                	xchg   %ax,%ax

801035f0 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
801035f0:	f3 0f 1e fb          	endbr32 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801035f4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801035f9:	ba 21 00 00 00       	mov    $0x21,%edx
801035fe:	ee                   	out    %al,(%dx)
801035ff:	ba a1 00 00 00       	mov    $0xa1,%edx
80103604:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103605:	c3                   	ret    
80103606:	66 90                	xchg   %ax,%ax
80103608:	66 90                	xchg   %ax,%ax
8010360a:	66 90                	xchg   %ax,%ax
8010360c:	66 90                	xchg   %ax,%ax
8010360e:	66 90                	xchg   %ax,%ax

80103610 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103610:	f3 0f 1e fb          	endbr32 
80103614:	55                   	push   %ebp
80103615:	89 e5                	mov    %esp,%ebp
80103617:	57                   	push   %edi
80103618:	56                   	push   %esi
80103619:	53                   	push   %ebx
8010361a:	83 ec 0c             	sub    $0xc,%esp
8010361d:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103620:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
80103623:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103629:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010362f:	e8 ec d9 ff ff       	call   80101020 <filealloc>
80103634:	89 03                	mov    %eax,(%ebx)
80103636:	85 c0                	test   %eax,%eax
80103638:	0f 84 ac 00 00 00    	je     801036ea <pipealloc+0xda>
8010363e:	e8 dd d9 ff ff       	call   80101020 <filealloc>
80103643:	89 06                	mov    %eax,(%esi)
80103645:	85 c0                	test   %eax,%eax
80103647:	0f 84 8b 00 00 00    	je     801036d8 <pipealloc+0xc8>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
8010364d:	e8 fe f1 ff ff       	call   80102850 <kalloc>
80103652:	89 c7                	mov    %eax,%edi
80103654:	85 c0                	test   %eax,%eax
80103656:	0f 84 b4 00 00 00    	je     80103710 <pipealloc+0x100>
    goto bad;
  p->readopen = 1;
8010365c:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
80103663:	00 00 00 
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
80103666:	83 ec 08             	sub    $0x8,%esp
  p->writeopen = 1;
80103669:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80103670:	00 00 00 
  p->nwrite = 0;
80103673:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
8010367a:	00 00 00 
  p->nread = 0;
8010367d:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103684:	00 00 00 
  initlock(&p->lock, "pipe");
80103687:	68 bb 78 10 80       	push   $0x801078bb
8010368c:	50                   	push   %eax
8010368d:	e8 7e 0f 00 00       	call   80104610 <initlock>
  (*f0)->type = FD_PIPE;
80103692:	8b 03                	mov    (%ebx),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
80103694:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
80103697:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
8010369d:	8b 03                	mov    (%ebx),%eax
8010369f:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
801036a3:	8b 03                	mov    (%ebx),%eax
801036a5:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
801036a9:	8b 03                	mov    (%ebx),%eax
801036ab:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
801036ae:	8b 06                	mov    (%esi),%eax
801036b0:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
801036b6:	8b 06                	mov    (%esi),%eax
801036b8:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
801036bc:	8b 06                	mov    (%esi),%eax
801036be:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
801036c2:	8b 06                	mov    (%esi),%eax
801036c4:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
801036c7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801036ca:	31 c0                	xor    %eax,%eax
}
801036cc:	5b                   	pop    %ebx
801036cd:	5e                   	pop    %esi
801036ce:	5f                   	pop    %edi
801036cf:	5d                   	pop    %ebp
801036d0:	c3                   	ret    
801036d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*f0)
801036d8:	8b 03                	mov    (%ebx),%eax
801036da:	85 c0                	test   %eax,%eax
801036dc:	74 1e                	je     801036fc <pipealloc+0xec>
    fileclose(*f0);
801036de:	83 ec 0c             	sub    $0xc,%esp
801036e1:	50                   	push   %eax
801036e2:	e8 f9 d9 ff ff       	call   801010e0 <fileclose>
801036e7:	83 c4 10             	add    $0x10,%esp
  if(*f1)
801036ea:	8b 06                	mov    (%esi),%eax
801036ec:	85 c0                	test   %eax,%eax
801036ee:	74 0c                	je     801036fc <pipealloc+0xec>
    fileclose(*f1);
801036f0:	83 ec 0c             	sub    $0xc,%esp
801036f3:	50                   	push   %eax
801036f4:	e8 e7 d9 ff ff       	call   801010e0 <fileclose>
801036f9:	83 c4 10             	add    $0x10,%esp
}
801036fc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
801036ff:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103704:	5b                   	pop    %ebx
80103705:	5e                   	pop    %esi
80103706:	5f                   	pop    %edi
80103707:	5d                   	pop    %ebp
80103708:	c3                   	ret    
80103709:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*f0)
80103710:	8b 03                	mov    (%ebx),%eax
80103712:	85 c0                	test   %eax,%eax
80103714:	75 c8                	jne    801036de <pipealloc+0xce>
80103716:	eb d2                	jmp    801036ea <pipealloc+0xda>
80103718:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010371f:	90                   	nop

80103720 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103720:	f3 0f 1e fb          	endbr32 
80103724:	55                   	push   %ebp
80103725:	89 e5                	mov    %esp,%ebp
80103727:	56                   	push   %esi
80103728:	53                   	push   %ebx
80103729:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010372c:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010372f:	83 ec 0c             	sub    $0xc,%esp
80103732:	53                   	push   %ebx
80103733:	e8 58 10 00 00       	call   80104790 <acquire>
  if(writable){
80103738:	83 c4 10             	add    $0x10,%esp
8010373b:	85 f6                	test   %esi,%esi
8010373d:	74 41                	je     80103780 <pipeclose+0x60>
    p->writeopen = 0;
    wakeup(&p->nread);
8010373f:	83 ec 0c             	sub    $0xc,%esp
80103742:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
    p->writeopen = 0;
80103748:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
8010374f:	00 00 00 
    wakeup(&p->nread);
80103752:	50                   	push   %eax
80103753:	e8 b8 0b 00 00       	call   80104310 <wakeup>
80103758:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
8010375b:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
80103761:	85 d2                	test   %edx,%edx
80103763:	75 0a                	jne    8010376f <pipeclose+0x4f>
80103765:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
8010376b:	85 c0                	test   %eax,%eax
8010376d:	74 31                	je     801037a0 <pipeclose+0x80>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
8010376f:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80103772:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103775:	5b                   	pop    %ebx
80103776:	5e                   	pop    %esi
80103777:	5d                   	pop    %ebp
    release(&p->lock);
80103778:	e9 d3 10 00 00       	jmp    80104850 <release>
8010377d:	8d 76 00             	lea    0x0(%esi),%esi
    wakeup(&p->nwrite);
80103780:	83 ec 0c             	sub    $0xc,%esp
80103783:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
    p->readopen = 0;
80103789:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103790:	00 00 00 
    wakeup(&p->nwrite);
80103793:	50                   	push   %eax
80103794:	e8 77 0b 00 00       	call   80104310 <wakeup>
80103799:	83 c4 10             	add    $0x10,%esp
8010379c:	eb bd                	jmp    8010375b <pipeclose+0x3b>
8010379e:	66 90                	xchg   %ax,%ax
    release(&p->lock);
801037a0:	83 ec 0c             	sub    $0xc,%esp
801037a3:	53                   	push   %ebx
801037a4:	e8 a7 10 00 00       	call   80104850 <release>
    kfree((char*)p);
801037a9:	89 5d 08             	mov    %ebx,0x8(%ebp)
801037ac:	83 c4 10             	add    $0x10,%esp
}
801037af:	8d 65 f8             	lea    -0x8(%ebp),%esp
801037b2:	5b                   	pop    %ebx
801037b3:	5e                   	pop    %esi
801037b4:	5d                   	pop    %ebp
    kfree((char*)p);
801037b5:	e9 d6 ee ff ff       	jmp    80102690 <kfree>
801037ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801037c0 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
801037c0:	f3 0f 1e fb          	endbr32 
801037c4:	55                   	push   %ebp
801037c5:	89 e5                	mov    %esp,%ebp
801037c7:	57                   	push   %edi
801037c8:	56                   	push   %esi
801037c9:	53                   	push   %ebx
801037ca:	83 ec 28             	sub    $0x28,%esp
801037cd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
801037d0:	53                   	push   %ebx
801037d1:	e8 ba 0f 00 00       	call   80104790 <acquire>
  for(i = 0; i < n; i++){
801037d6:	8b 45 10             	mov    0x10(%ebp),%eax
801037d9:	83 c4 10             	add    $0x10,%esp
801037dc:	85 c0                	test   %eax,%eax
801037de:	0f 8e bc 00 00 00    	jle    801038a0 <pipewrite+0xe0>
801037e4:	8b 45 0c             	mov    0xc(%ebp),%eax
801037e7:	8b 8b 38 02 00 00    	mov    0x238(%ebx),%ecx
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
801037ed:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
801037f3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801037f6:	03 45 10             	add    0x10(%ebp),%eax
801037f9:	89 45 e0             	mov    %eax,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801037fc:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103802:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103808:	89 ca                	mov    %ecx,%edx
8010380a:	05 00 02 00 00       	add    $0x200,%eax
8010380f:	39 c1                	cmp    %eax,%ecx
80103811:	74 3b                	je     8010384e <pipewrite+0x8e>
80103813:	eb 63                	jmp    80103878 <pipewrite+0xb8>
80103815:	8d 76 00             	lea    0x0(%esi),%esi
      if(p->readopen == 0 || myproc()->killed){
80103818:	e8 73 03 00 00       	call   80103b90 <myproc>
8010381d:	8b 48 24             	mov    0x24(%eax),%ecx
80103820:	85 c9                	test   %ecx,%ecx
80103822:	75 34                	jne    80103858 <pipewrite+0x98>
      wakeup(&p->nread);
80103824:	83 ec 0c             	sub    $0xc,%esp
80103827:	57                   	push   %edi
80103828:	e8 e3 0a 00 00       	call   80104310 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010382d:	58                   	pop    %eax
8010382e:	5a                   	pop    %edx
8010382f:	53                   	push   %ebx
80103830:	56                   	push   %esi
80103831:	e8 1a 09 00 00       	call   80104150 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103836:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
8010383c:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
80103842:	83 c4 10             	add    $0x10,%esp
80103845:	05 00 02 00 00       	add    $0x200,%eax
8010384a:	39 c2                	cmp    %eax,%edx
8010384c:	75 2a                	jne    80103878 <pipewrite+0xb8>
      if(p->readopen == 0 || myproc()->killed){
8010384e:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80103854:	85 c0                	test   %eax,%eax
80103856:	75 c0                	jne    80103818 <pipewrite+0x58>
        release(&p->lock);
80103858:	83 ec 0c             	sub    $0xc,%esp
8010385b:	53                   	push   %ebx
8010385c:	e8 ef 0f 00 00       	call   80104850 <release>
        return -1;
80103861:	83 c4 10             	add    $0x10,%esp
80103864:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103869:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010386c:	5b                   	pop    %ebx
8010386d:	5e                   	pop    %esi
8010386e:	5f                   	pop    %edi
8010386f:	5d                   	pop    %ebp
80103870:	c3                   	ret    
80103871:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103878:	8b 75 e4             	mov    -0x1c(%ebp),%esi
8010387b:	8d 4a 01             	lea    0x1(%edx),%ecx
8010387e:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
80103884:	89 8b 38 02 00 00    	mov    %ecx,0x238(%ebx)
8010388a:	0f b6 06             	movzbl (%esi),%eax
8010388d:	83 c6 01             	add    $0x1,%esi
80103890:	89 75 e4             	mov    %esi,-0x1c(%ebp)
80103893:	88 44 13 34          	mov    %al,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
80103897:	3b 75 e0             	cmp    -0x20(%ebp),%esi
8010389a:	0f 85 5c ff ff ff    	jne    801037fc <pipewrite+0x3c>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
801038a0:	83 ec 0c             	sub    $0xc,%esp
801038a3:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
801038a9:	50                   	push   %eax
801038aa:	e8 61 0a 00 00       	call   80104310 <wakeup>
  release(&p->lock);
801038af:	89 1c 24             	mov    %ebx,(%esp)
801038b2:	e8 99 0f 00 00       	call   80104850 <release>
  return n;
801038b7:	8b 45 10             	mov    0x10(%ebp),%eax
801038ba:	83 c4 10             	add    $0x10,%esp
801038bd:	eb aa                	jmp    80103869 <pipewrite+0xa9>
801038bf:	90                   	nop

801038c0 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
801038c0:	f3 0f 1e fb          	endbr32 
801038c4:	55                   	push   %ebp
801038c5:	89 e5                	mov    %esp,%ebp
801038c7:	57                   	push   %edi
801038c8:	56                   	push   %esi
801038c9:	53                   	push   %ebx
801038ca:	83 ec 18             	sub    $0x18,%esp
801038cd:	8b 75 08             	mov    0x8(%ebp),%esi
801038d0:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
801038d3:	56                   	push   %esi
801038d4:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
801038da:	e8 b1 0e 00 00       	call   80104790 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801038df:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
801038e5:	83 c4 10             	add    $0x10,%esp
801038e8:	39 86 38 02 00 00    	cmp    %eax,0x238(%esi)
801038ee:	74 33                	je     80103923 <piperead+0x63>
801038f0:	eb 3b                	jmp    8010392d <piperead+0x6d>
801038f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(myproc()->killed){
801038f8:	e8 93 02 00 00       	call   80103b90 <myproc>
801038fd:	8b 48 24             	mov    0x24(%eax),%ecx
80103900:	85 c9                	test   %ecx,%ecx
80103902:	0f 85 88 00 00 00    	jne    80103990 <piperead+0xd0>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103908:	83 ec 08             	sub    $0x8,%esp
8010390b:	56                   	push   %esi
8010390c:	53                   	push   %ebx
8010390d:	e8 3e 08 00 00       	call   80104150 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103912:	8b 86 38 02 00 00    	mov    0x238(%esi),%eax
80103918:	83 c4 10             	add    $0x10,%esp
8010391b:	39 86 34 02 00 00    	cmp    %eax,0x234(%esi)
80103921:	75 0a                	jne    8010392d <piperead+0x6d>
80103923:	8b 86 40 02 00 00    	mov    0x240(%esi),%eax
80103929:	85 c0                	test   %eax,%eax
8010392b:	75 cb                	jne    801038f8 <piperead+0x38>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
8010392d:	8b 55 10             	mov    0x10(%ebp),%edx
80103930:	31 db                	xor    %ebx,%ebx
80103932:	85 d2                	test   %edx,%edx
80103934:	7f 28                	jg     8010395e <piperead+0x9e>
80103936:	eb 34                	jmp    8010396c <piperead+0xac>
80103938:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010393f:	90                   	nop
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103940:	8d 48 01             	lea    0x1(%eax),%ecx
80103943:	25 ff 01 00 00       	and    $0x1ff,%eax
80103948:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
8010394e:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
80103953:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103956:	83 c3 01             	add    $0x1,%ebx
80103959:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010395c:	74 0e                	je     8010396c <piperead+0xac>
    if(p->nread == p->nwrite)
8010395e:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103964:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
8010396a:	75 d4                	jne    80103940 <piperead+0x80>
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
8010396c:	83 ec 0c             	sub    $0xc,%esp
8010396f:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103975:	50                   	push   %eax
80103976:	e8 95 09 00 00       	call   80104310 <wakeup>
  release(&p->lock);
8010397b:	89 34 24             	mov    %esi,(%esp)
8010397e:	e8 cd 0e 00 00       	call   80104850 <release>
  return i;
80103983:	83 c4 10             	add    $0x10,%esp
}
80103986:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103989:	89 d8                	mov    %ebx,%eax
8010398b:	5b                   	pop    %ebx
8010398c:	5e                   	pop    %esi
8010398d:	5f                   	pop    %edi
8010398e:	5d                   	pop    %ebp
8010398f:	c3                   	ret    
      release(&p->lock);
80103990:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103993:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
80103998:	56                   	push   %esi
80103999:	e8 b2 0e 00 00       	call   80104850 <release>
      return -1;
8010399e:	83 c4 10             	add    $0x10,%esp
}
801039a1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801039a4:	89 d8                	mov    %ebx,%eax
801039a6:	5b                   	pop    %ebx
801039a7:	5e                   	pop    %esi
801039a8:	5f                   	pop    %edi
801039a9:	5d                   	pop    %ebp
801039aa:	c3                   	ret    
801039ab:	66 90                	xchg   %ax,%ax
801039ad:	66 90                	xchg   %ax,%ax
801039af:	90                   	nop

801039b0 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
801039b0:	55                   	push   %ebp
801039b1:	89 e5                	mov    %esp,%ebp
801039b3:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801039b4:	bb 74 2d 11 80       	mov    $0x80112d74,%ebx
{
801039b9:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
801039bc:	68 40 2d 11 80       	push   $0x80112d40
801039c1:	e8 ca 0d 00 00       	call   80104790 <acquire>
801039c6:	83 c4 10             	add    $0x10,%esp
801039c9:	eb 14                	jmp    801039df <allocproc+0x2f>
801039cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801039cf:	90                   	nop
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801039d0:	83 eb 80             	sub    $0xffffff80,%ebx
801039d3:	81 fb 74 4d 11 80    	cmp    $0x80114d74,%ebx
801039d9:	0f 84 81 00 00 00    	je     80103a60 <allocproc+0xb0>
    if(p->state == UNUSED)
801039df:	8b 43 0c             	mov    0xc(%ebx),%eax
801039e2:	85 c0                	test   %eax,%eax
801039e4:	75 ea                	jne    801039d0 <allocproc+0x20>
  return 0;

found:
  p->state = EMBRYO;

  p->pid = nextpid++;
801039e6:	a1 04 a0 10 80       	mov    0x8010a004,%eax
  p->counter = 0;

  release(&ptable.lock);
801039eb:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
801039ee:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->counter = 0;
801039f5:	c7 43 7c 00 00 00 00 	movl   $0x0,0x7c(%ebx)
  p->pid = nextpid++;
801039fc:	89 43 10             	mov    %eax,0x10(%ebx)
801039ff:	8d 50 01             	lea    0x1(%eax),%edx
  release(&ptable.lock);
80103a02:	68 40 2d 11 80       	push   $0x80112d40
  p->pid = nextpid++;
80103a07:	89 15 04 a0 10 80    	mov    %edx,0x8010a004
  release(&ptable.lock);
80103a0d:	e8 3e 0e 00 00       	call   80104850 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80103a12:	e8 39 ee ff ff       	call   80102850 <kalloc>
80103a17:	83 c4 10             	add    $0x10,%esp
80103a1a:	89 43 08             	mov    %eax,0x8(%ebx)
80103a1d:	85 c0                	test   %eax,%eax
80103a1f:	74 58                	je     80103a79 <allocproc+0xc9>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103a21:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
80103a27:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
80103a2a:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
80103a2f:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
80103a32:	c7 40 14 1f 5b 10 80 	movl   $0x80105b1f,0x14(%eax)
  p->context = (struct context*)sp;
80103a39:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103a3c:	6a 14                	push   $0x14
80103a3e:	6a 00                	push   $0x0
80103a40:	50                   	push   %eax
80103a41:	e8 5a 0e 00 00       	call   801048a0 <memset>
  p->context->eip = (uint)forkret;
80103a46:	8b 43 1c             	mov    0x1c(%ebx),%eax

  return p;
80103a49:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
80103a4c:	c7 40 10 90 3a 10 80 	movl   $0x80103a90,0x10(%eax)
}
80103a53:	89 d8                	mov    %ebx,%eax
80103a55:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103a58:	c9                   	leave  
80103a59:	c3                   	ret    
80103a5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  release(&ptable.lock);
80103a60:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80103a63:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
80103a65:	68 40 2d 11 80       	push   $0x80112d40
80103a6a:	e8 e1 0d 00 00       	call   80104850 <release>
}
80103a6f:	89 d8                	mov    %ebx,%eax
  return 0;
80103a71:	83 c4 10             	add    $0x10,%esp
}
80103a74:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103a77:	c9                   	leave  
80103a78:	c3                   	ret    
    p->state = UNUSED;
80103a79:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
80103a80:	31 db                	xor    %ebx,%ebx
}
80103a82:	89 d8                	mov    %ebx,%eax
80103a84:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103a87:	c9                   	leave  
80103a88:	c3                   	ret    
80103a89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103a90 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80103a90:	f3 0f 1e fb          	endbr32 
80103a94:	55                   	push   %ebp
80103a95:	89 e5                	mov    %esp,%ebp
80103a97:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80103a9a:	68 40 2d 11 80       	push   $0x80112d40
80103a9f:	e8 ac 0d 00 00       	call   80104850 <release>

  if (first) {
80103aa4:	a1 00 a0 10 80       	mov    0x8010a000,%eax
80103aa9:	83 c4 10             	add    $0x10,%esp
80103aac:	85 c0                	test   %eax,%eax
80103aae:	75 08                	jne    80103ab8 <forkret+0x28>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
80103ab0:	c9                   	leave  
80103ab1:	c3                   	ret    
80103ab2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    first = 0;
80103ab8:	c7 05 00 a0 10 80 00 	movl   $0x0,0x8010a000
80103abf:	00 00 00 
    iinit(ROOTDEV);
80103ac2:	83 ec 0c             	sub    $0xc,%esp
80103ac5:	6a 01                	push   $0x1
80103ac7:	e8 94 dc ff ff       	call   80101760 <iinit>
    initlog(ROOTDEV);
80103acc:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80103ad3:	e8 d8 f3 ff ff       	call   80102eb0 <initlog>
}
80103ad8:	83 c4 10             	add    $0x10,%esp
80103adb:	c9                   	leave  
80103adc:	c3                   	ret    
80103add:	8d 76 00             	lea    0x0(%esi),%esi

80103ae0 <pinit>:
{
80103ae0:	f3 0f 1e fb          	endbr32 
80103ae4:	55                   	push   %ebp
80103ae5:	89 e5                	mov    %esp,%ebp
80103ae7:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80103aea:	68 c0 78 10 80       	push   $0x801078c0
80103aef:	68 40 2d 11 80       	push   $0x80112d40
80103af4:	e8 17 0b 00 00       	call   80104610 <initlock>
}
80103af9:	83 c4 10             	add    $0x10,%esp
80103afc:	c9                   	leave  
80103afd:	c3                   	ret    
80103afe:	66 90                	xchg   %ax,%ax

80103b00 <mycpu>:
{
80103b00:	f3 0f 1e fb          	endbr32 
80103b04:	55                   	push   %ebp
80103b05:	89 e5                	mov    %esp,%ebp
80103b07:	56                   	push   %esi
80103b08:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103b09:	9c                   	pushf  
80103b0a:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103b0b:	f6 c4 02             	test   $0x2,%ah
80103b0e:	75 4a                	jne    80103b5a <mycpu+0x5a>
  apicid = lapicid();
80103b10:	e8 ab ef ff ff       	call   80102ac0 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80103b15:	8b 35 20 2d 11 80    	mov    0x80112d20,%esi
  apicid = lapicid();
80103b1b:	89 c3                	mov    %eax,%ebx
  for (i = 0; i < ncpu; ++i) {
80103b1d:	85 f6                	test   %esi,%esi
80103b1f:	7e 2c                	jle    80103b4d <mycpu+0x4d>
80103b21:	31 d2                	xor    %edx,%edx
80103b23:	eb 0a                	jmp    80103b2f <mycpu+0x2f>
80103b25:	8d 76 00             	lea    0x0(%esi),%esi
80103b28:	83 c2 01             	add    $0x1,%edx
80103b2b:	39 f2                	cmp    %esi,%edx
80103b2d:	74 1e                	je     80103b4d <mycpu+0x4d>
    if (cpus[i].apicid == apicid)
80103b2f:	69 ca b0 00 00 00    	imul   $0xb0,%edx,%ecx
80103b35:	0f b6 81 a0 27 11 80 	movzbl -0x7feed860(%ecx),%eax
80103b3c:	39 d8                	cmp    %ebx,%eax
80103b3e:	75 e8                	jne    80103b28 <mycpu+0x28>
}
80103b40:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return &cpus[i];
80103b43:	8d 81 a0 27 11 80    	lea    -0x7feed860(%ecx),%eax
}
80103b49:	5b                   	pop    %ebx
80103b4a:	5e                   	pop    %esi
80103b4b:	5d                   	pop    %ebp
80103b4c:	c3                   	ret    
  panic("unknown apicid\n");
80103b4d:	83 ec 0c             	sub    $0xc,%esp
80103b50:	68 c7 78 10 80       	push   $0x801078c7
80103b55:	e8 36 c8 ff ff       	call   80100390 <panic>
    panic("mycpu called with interrupts enabled\n");
80103b5a:	83 ec 0c             	sub    $0xc,%esp
80103b5d:	68 a4 79 10 80       	push   $0x801079a4
80103b62:	e8 29 c8 ff ff       	call   80100390 <panic>
80103b67:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103b6e:	66 90                	xchg   %ax,%ax

80103b70 <cpuid>:
cpuid() {
80103b70:	f3 0f 1e fb          	endbr32 
80103b74:	55                   	push   %ebp
80103b75:	89 e5                	mov    %esp,%ebp
80103b77:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103b7a:	e8 81 ff ff ff       	call   80103b00 <mycpu>
}
80103b7f:	c9                   	leave  
  return mycpu()-cpus;
80103b80:	2d a0 27 11 80       	sub    $0x801127a0,%eax
80103b85:	c1 f8 04             	sar    $0x4,%eax
80103b88:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
80103b8e:	c3                   	ret    
80103b8f:	90                   	nop

80103b90 <myproc>:
myproc(void) {
80103b90:	f3 0f 1e fb          	endbr32 
80103b94:	55                   	push   %ebp
80103b95:	89 e5                	mov    %esp,%ebp
80103b97:	53                   	push   %ebx
80103b98:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80103b9b:	e8 f0 0a 00 00       	call   80104690 <pushcli>
  c = mycpu();
80103ba0:	e8 5b ff ff ff       	call   80103b00 <mycpu>
  p = c->proc;
80103ba5:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103bab:	e8 30 0b 00 00       	call   801046e0 <popcli>
}
80103bb0:	83 c4 04             	add    $0x4,%esp
80103bb3:	89 d8                	mov    %ebx,%eax
80103bb5:	5b                   	pop    %ebx
80103bb6:	5d                   	pop    %ebp
80103bb7:	c3                   	ret    
80103bb8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103bbf:	90                   	nop

80103bc0 <userinit>:
{
80103bc0:	f3 0f 1e fb          	endbr32 
80103bc4:	55                   	push   %ebp
80103bc5:	89 e5                	mov    %esp,%ebp
80103bc7:	53                   	push   %ebx
80103bc8:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
80103bcb:	e8 e0 fd ff ff       	call   801039b0 <allocproc>
80103bd0:	89 c3                	mov    %eax,%ebx
  initproc = p;
80103bd2:	a3 d8 a5 10 80       	mov    %eax,0x8010a5d8
  if((p->pgdir = setupkvm()) == 0)
80103bd7:	e8 04 35 00 00       	call   801070e0 <setupkvm>
80103bdc:	89 43 04             	mov    %eax,0x4(%ebx)
80103bdf:	85 c0                	test   %eax,%eax
80103be1:	0f 84 bd 00 00 00    	je     80103ca4 <userinit+0xe4>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103be7:	83 ec 04             	sub    $0x4,%esp
80103bea:	68 2c 00 00 00       	push   $0x2c
80103bef:	68 60 a4 10 80       	push   $0x8010a460
80103bf4:	50                   	push   %eax
80103bf5:	e8 b6 31 00 00       	call   80106db0 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80103bfa:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80103bfd:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103c03:	6a 4c                	push   $0x4c
80103c05:	6a 00                	push   $0x0
80103c07:	ff 73 18             	pushl  0x18(%ebx)
80103c0a:	e8 91 0c 00 00       	call   801048a0 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103c0f:	8b 43 18             	mov    0x18(%ebx),%eax
80103c12:	ba 1b 00 00 00       	mov    $0x1b,%edx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103c17:	83 c4 0c             	add    $0xc,%esp
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103c1a:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103c1f:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103c23:	8b 43 18             	mov    0x18(%ebx),%eax
80103c26:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103c2a:	8b 43 18             	mov    0x18(%ebx),%eax
80103c2d:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103c31:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103c35:	8b 43 18             	mov    0x18(%ebx),%eax
80103c38:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103c3c:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103c40:	8b 43 18             	mov    0x18(%ebx),%eax
80103c43:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103c4a:	8b 43 18             	mov    0x18(%ebx),%eax
80103c4d:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103c54:	8b 43 18             	mov    0x18(%ebx),%eax
80103c57:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103c5e:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103c61:	6a 10                	push   $0x10
80103c63:	68 f0 78 10 80       	push   $0x801078f0
80103c68:	50                   	push   %eax
80103c69:	e8 f2 0d 00 00       	call   80104a60 <safestrcpy>
  p->cwd = namei("/");
80103c6e:	c7 04 24 f9 78 10 80 	movl   $0x801078f9,(%esp)
80103c75:	e8 d6 e5 ff ff       	call   80102250 <namei>
80103c7a:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80103c7d:	c7 04 24 40 2d 11 80 	movl   $0x80112d40,(%esp)
80103c84:	e8 07 0b 00 00       	call   80104790 <acquire>
  p->state = RUNNABLE;
80103c89:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
80103c90:	c7 04 24 40 2d 11 80 	movl   $0x80112d40,(%esp)
80103c97:	e8 b4 0b 00 00       	call   80104850 <release>
}
80103c9c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103c9f:	83 c4 10             	add    $0x10,%esp
80103ca2:	c9                   	leave  
80103ca3:	c3                   	ret    
    panic("userinit: out of memory?");
80103ca4:	83 ec 0c             	sub    $0xc,%esp
80103ca7:	68 d7 78 10 80       	push   $0x801078d7
80103cac:	e8 df c6 ff ff       	call   80100390 <panic>
80103cb1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103cb8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103cbf:	90                   	nop

80103cc0 <growproc>:
{
80103cc0:	f3 0f 1e fb          	endbr32 
80103cc4:	55                   	push   %ebp
80103cc5:	89 e5                	mov    %esp,%ebp
80103cc7:	56                   	push   %esi
80103cc8:	53                   	push   %ebx
80103cc9:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103ccc:	e8 bf 09 00 00       	call   80104690 <pushcli>
  c = mycpu();
80103cd1:	e8 2a fe ff ff       	call   80103b00 <mycpu>
  p = c->proc;
80103cd6:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103cdc:	e8 ff 09 00 00       	call   801046e0 <popcli>
  sz = curproc->sz;
80103ce1:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80103ce3:	85 f6                	test   %esi,%esi
80103ce5:	7f 19                	jg     80103d00 <growproc+0x40>
  } else if(n < 0){
80103ce7:	75 37                	jne    80103d20 <growproc+0x60>
  switchuvm(curproc);
80103ce9:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80103cec:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103cee:	53                   	push   %ebx
80103cef:	e8 ac 2f 00 00       	call   80106ca0 <switchuvm>
  return 0;
80103cf4:	83 c4 10             	add    $0x10,%esp
80103cf7:	31 c0                	xor    %eax,%eax
}
80103cf9:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103cfc:	5b                   	pop    %ebx
80103cfd:	5e                   	pop    %esi
80103cfe:	5d                   	pop    %ebp
80103cff:	c3                   	ret    
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103d00:	83 ec 04             	sub    $0x4,%esp
80103d03:	01 c6                	add    %eax,%esi
80103d05:	56                   	push   %esi
80103d06:	50                   	push   %eax
80103d07:	ff 73 04             	pushl  0x4(%ebx)
80103d0a:	e8 f1 31 00 00       	call   80106f00 <allocuvm>
80103d0f:	83 c4 10             	add    $0x10,%esp
80103d12:	85 c0                	test   %eax,%eax
80103d14:	75 d3                	jne    80103ce9 <growproc+0x29>
      return -1;
80103d16:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103d1b:	eb dc                	jmp    80103cf9 <growproc+0x39>
80103d1d:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103d20:	83 ec 04             	sub    $0x4,%esp
80103d23:	01 c6                	add    %eax,%esi
80103d25:	56                   	push   %esi
80103d26:	50                   	push   %eax
80103d27:	ff 73 04             	pushl  0x4(%ebx)
80103d2a:	e8 01 33 00 00       	call   80107030 <deallocuvm>
80103d2f:	83 c4 10             	add    $0x10,%esp
80103d32:	85 c0                	test   %eax,%eax
80103d34:	75 b3                	jne    80103ce9 <growproc+0x29>
80103d36:	eb de                	jmp    80103d16 <growproc+0x56>
80103d38:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103d3f:	90                   	nop

80103d40 <fork>:
{
80103d40:	f3 0f 1e fb          	endbr32 
80103d44:	55                   	push   %ebp
80103d45:	89 e5                	mov    %esp,%ebp
80103d47:	57                   	push   %edi
80103d48:	56                   	push   %esi
80103d49:	53                   	push   %ebx
80103d4a:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80103d4d:	e8 3e 09 00 00       	call   80104690 <pushcli>
  c = mycpu();
80103d52:	e8 a9 fd ff ff       	call   80103b00 <mycpu>
  p = c->proc;
80103d57:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103d5d:	e8 7e 09 00 00       	call   801046e0 <popcli>
  if((np = allocproc()) == 0){
80103d62:	e8 49 fc ff ff       	call   801039b0 <allocproc>
80103d67:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103d6a:	85 c0                	test   %eax,%eax
80103d6c:	0f 84 bb 00 00 00    	je     80103e2d <fork+0xed>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103d72:	83 ec 08             	sub    $0x8,%esp
80103d75:	ff 33                	pushl  (%ebx)
80103d77:	89 c7                	mov    %eax,%edi
80103d79:	ff 73 04             	pushl  0x4(%ebx)
80103d7c:	e8 2f 34 00 00       	call   801071b0 <copyuvm>
80103d81:	83 c4 10             	add    $0x10,%esp
80103d84:	89 47 04             	mov    %eax,0x4(%edi)
80103d87:	85 c0                	test   %eax,%eax
80103d89:	0f 84 a5 00 00 00    	je     80103e34 <fork+0xf4>
  np->sz = curproc->sz;
80103d8f:	8b 03                	mov    (%ebx),%eax
80103d91:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103d94:	89 01                	mov    %eax,(%ecx)
  *np->tf = *curproc->tf;
80103d96:	8b 79 18             	mov    0x18(%ecx),%edi
  np->parent = curproc;
80103d99:	89 c8                	mov    %ecx,%eax
80103d9b:	89 59 14             	mov    %ebx,0x14(%ecx)
  *np->tf = *curproc->tf;
80103d9e:	b9 13 00 00 00       	mov    $0x13,%ecx
80103da3:	8b 73 18             	mov    0x18(%ebx),%esi
80103da6:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80103da8:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80103daa:	8b 40 18             	mov    0x18(%eax),%eax
80103dad:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
  for(i = 0; i < NOFILE; i++)
80103db4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[i])
80103db8:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103dbc:	85 c0                	test   %eax,%eax
80103dbe:	74 13                	je     80103dd3 <fork+0x93>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103dc0:	83 ec 0c             	sub    $0xc,%esp
80103dc3:	50                   	push   %eax
80103dc4:	e8 c7 d2 ff ff       	call   80101090 <filedup>
80103dc9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103dcc:	83 c4 10             	add    $0x10,%esp
80103dcf:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
80103dd3:	83 c6 01             	add    $0x1,%esi
80103dd6:	83 fe 10             	cmp    $0x10,%esi
80103dd9:	75 dd                	jne    80103db8 <fork+0x78>
  np->cwd = idup(curproc->cwd);
80103ddb:	83 ec 0c             	sub    $0xc,%esp
80103dde:	ff 73 68             	pushl  0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103de1:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
80103de4:	e8 67 db ff ff       	call   80101950 <idup>
80103de9:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103dec:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80103def:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103df2:	8d 47 6c             	lea    0x6c(%edi),%eax
80103df5:	6a 10                	push   $0x10
80103df7:	53                   	push   %ebx
80103df8:	50                   	push   %eax
80103df9:	e8 62 0c 00 00       	call   80104a60 <safestrcpy>
  pid = np->pid;
80103dfe:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80103e01:	c7 04 24 40 2d 11 80 	movl   $0x80112d40,(%esp)
80103e08:	e8 83 09 00 00       	call   80104790 <acquire>
  np->state = RUNNABLE;
80103e0d:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
80103e14:	c7 04 24 40 2d 11 80 	movl   $0x80112d40,(%esp)
80103e1b:	e8 30 0a 00 00       	call   80104850 <release>
  return pid;
80103e20:	83 c4 10             	add    $0x10,%esp
}
80103e23:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103e26:	89 d8                	mov    %ebx,%eax
80103e28:	5b                   	pop    %ebx
80103e29:	5e                   	pop    %esi
80103e2a:	5f                   	pop    %edi
80103e2b:	5d                   	pop    %ebp
80103e2c:	c3                   	ret    
    return -1;
80103e2d:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103e32:	eb ef                	jmp    80103e23 <fork+0xe3>
    kfree(np->kstack);
80103e34:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103e37:	83 ec 0c             	sub    $0xc,%esp
80103e3a:	ff 73 08             	pushl  0x8(%ebx)
80103e3d:	e8 4e e8 ff ff       	call   80102690 <kfree>
    np->kstack = 0;
80103e42:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    return -1;
80103e49:	83 c4 10             	add    $0x10,%esp
    np->state = UNUSED;
80103e4c:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80103e53:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103e58:	eb c9                	jmp    80103e23 <fork+0xe3>
80103e5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103e60 <scheduler>:
{
80103e60:	f3 0f 1e fb          	endbr32 
80103e64:	55                   	push   %ebp
80103e65:	89 e5                	mov    %esp,%ebp
80103e67:	57                   	push   %edi
80103e68:	56                   	push   %esi
80103e69:	53                   	push   %ebx
80103e6a:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
80103e6d:	e8 8e fc ff ff       	call   80103b00 <mycpu>
  c->proc = 0;
80103e72:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103e79:	00 00 00 
  struct cpu *c = mycpu();
80103e7c:	89 c6                	mov    %eax,%esi
  c->proc = 0;
80103e7e:	8d 78 04             	lea    0x4(%eax),%edi
80103e81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  asm volatile("sti");
80103e88:	fb                   	sti    
    acquire(&ptable.lock);
80103e89:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103e8c:	bb 74 2d 11 80       	mov    $0x80112d74,%ebx
    acquire(&ptable.lock);
80103e91:	68 40 2d 11 80       	push   $0x80112d40
80103e96:	e8 f5 08 00 00       	call   80104790 <acquire>
80103e9b:	83 c4 10             	add    $0x10,%esp
80103e9e:	66 90                	xchg   %ax,%ax
      if(p->state != RUNNABLE)
80103ea0:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80103ea4:	75 33                	jne    80103ed9 <scheduler+0x79>
      switchuvm(p);
80103ea6:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
80103ea9:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
80103eaf:	53                   	push   %ebx
80103eb0:	e8 eb 2d 00 00       	call   80106ca0 <switchuvm>
      swtch(&(c->scheduler), p->context);
80103eb5:	58                   	pop    %eax
80103eb6:	5a                   	pop    %edx
80103eb7:	ff 73 1c             	pushl  0x1c(%ebx)
80103eba:	57                   	push   %edi
      p->state = RUNNING;
80103ebb:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), p->context);
80103ec2:	e8 fc 0b 00 00       	call   80104ac3 <swtch>
      switchkvm();
80103ec7:	e8 b4 2d 00 00       	call   80106c80 <switchkvm>
      c->proc = 0;
80103ecc:	83 c4 10             	add    $0x10,%esp
80103ecf:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80103ed6:	00 00 00 
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103ed9:	83 eb 80             	sub    $0xffffff80,%ebx
80103edc:	81 fb 74 4d 11 80    	cmp    $0x80114d74,%ebx
80103ee2:	75 bc                	jne    80103ea0 <scheduler+0x40>
    release(&ptable.lock);
80103ee4:	83 ec 0c             	sub    $0xc,%esp
80103ee7:	68 40 2d 11 80       	push   $0x80112d40
80103eec:	e8 5f 09 00 00       	call   80104850 <release>
    sti();
80103ef1:	83 c4 10             	add    $0x10,%esp
80103ef4:	eb 92                	jmp    80103e88 <scheduler+0x28>
80103ef6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103efd:	8d 76 00             	lea    0x0(%esi),%esi

80103f00 <sched>:
{
80103f00:	f3 0f 1e fb          	endbr32 
80103f04:	55                   	push   %ebp
80103f05:	89 e5                	mov    %esp,%ebp
80103f07:	56                   	push   %esi
80103f08:	53                   	push   %ebx
  pushcli();
80103f09:	e8 82 07 00 00       	call   80104690 <pushcli>
  c = mycpu();
80103f0e:	e8 ed fb ff ff       	call   80103b00 <mycpu>
  p = c->proc;
80103f13:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103f19:	e8 c2 07 00 00       	call   801046e0 <popcli>
  if(!holding(&ptable.lock))
80103f1e:	83 ec 0c             	sub    $0xc,%esp
80103f21:	68 40 2d 11 80       	push   $0x80112d40
80103f26:	e8 15 08 00 00       	call   80104740 <holding>
80103f2b:	83 c4 10             	add    $0x10,%esp
80103f2e:	85 c0                	test   %eax,%eax
80103f30:	74 4f                	je     80103f81 <sched+0x81>
  if(mycpu()->ncli != 1)
80103f32:	e8 c9 fb ff ff       	call   80103b00 <mycpu>
80103f37:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103f3e:	75 68                	jne    80103fa8 <sched+0xa8>
  if(p->state == RUNNING)
80103f40:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80103f44:	74 55                	je     80103f9b <sched+0x9b>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103f46:	9c                   	pushf  
80103f47:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103f48:	f6 c4 02             	test   $0x2,%ah
80103f4b:	75 41                	jne    80103f8e <sched+0x8e>
  intena = mycpu()->intena;
80103f4d:	e8 ae fb ff ff       	call   80103b00 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80103f52:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80103f55:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80103f5b:	e8 a0 fb ff ff       	call   80103b00 <mycpu>
80103f60:	83 ec 08             	sub    $0x8,%esp
80103f63:	ff 70 04             	pushl  0x4(%eax)
80103f66:	53                   	push   %ebx
80103f67:	e8 57 0b 00 00       	call   80104ac3 <swtch>
  mycpu()->intena = intena;
80103f6c:	e8 8f fb ff ff       	call   80103b00 <mycpu>
}
80103f71:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80103f74:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103f7a:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103f7d:	5b                   	pop    %ebx
80103f7e:	5e                   	pop    %esi
80103f7f:	5d                   	pop    %ebp
80103f80:	c3                   	ret    
    panic("sched ptable.lock");
80103f81:	83 ec 0c             	sub    $0xc,%esp
80103f84:	68 fb 78 10 80       	push   $0x801078fb
80103f89:	e8 02 c4 ff ff       	call   80100390 <panic>
    panic("sched interruptible");
80103f8e:	83 ec 0c             	sub    $0xc,%esp
80103f91:	68 27 79 10 80       	push   $0x80107927
80103f96:	e8 f5 c3 ff ff       	call   80100390 <panic>
    panic("sched running");
80103f9b:	83 ec 0c             	sub    $0xc,%esp
80103f9e:	68 19 79 10 80       	push   $0x80107919
80103fa3:	e8 e8 c3 ff ff       	call   80100390 <panic>
    panic("sched locks");
80103fa8:	83 ec 0c             	sub    $0xc,%esp
80103fab:	68 0d 79 10 80       	push   $0x8010790d
80103fb0:	e8 db c3 ff ff       	call   80100390 <panic>
80103fb5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103fbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103fc0 <exit>:
{
80103fc0:	f3 0f 1e fb          	endbr32 
80103fc4:	55                   	push   %ebp
80103fc5:	89 e5                	mov    %esp,%ebp
80103fc7:	57                   	push   %edi
80103fc8:	56                   	push   %esi
80103fc9:	53                   	push   %ebx
80103fca:	83 ec 0c             	sub    $0xc,%esp
  pushcli();
80103fcd:	e8 be 06 00 00       	call   80104690 <pushcli>
  c = mycpu();
80103fd2:	e8 29 fb ff ff       	call   80103b00 <mycpu>
  p = c->proc;
80103fd7:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80103fdd:	e8 fe 06 00 00       	call   801046e0 <popcli>
  if(curproc == initproc)
80103fe2:	8d 5e 28             	lea    0x28(%esi),%ebx
80103fe5:	8d 7e 68             	lea    0x68(%esi),%edi
80103fe8:	39 35 d8 a5 10 80    	cmp    %esi,0x8010a5d8
80103fee:	0f 84 f3 00 00 00    	je     801040e7 <exit+0x127>
80103ff4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd]){
80103ff8:	8b 03                	mov    (%ebx),%eax
80103ffa:	85 c0                	test   %eax,%eax
80103ffc:	74 12                	je     80104010 <exit+0x50>
      fileclose(curproc->ofile[fd]);
80103ffe:	83 ec 0c             	sub    $0xc,%esp
80104001:	50                   	push   %eax
80104002:	e8 d9 d0 ff ff       	call   801010e0 <fileclose>
      curproc->ofile[fd] = 0;
80104007:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
8010400d:	83 c4 10             	add    $0x10,%esp
  for(fd = 0; fd < NOFILE; fd++){
80104010:	83 c3 04             	add    $0x4,%ebx
80104013:	39 df                	cmp    %ebx,%edi
80104015:	75 e1                	jne    80103ff8 <exit+0x38>
  begin_op();
80104017:	e8 34 ef ff ff       	call   80102f50 <begin_op>
  iput(curproc->cwd);
8010401c:	83 ec 0c             	sub    $0xc,%esp
8010401f:	ff 76 68             	pushl  0x68(%esi)
80104022:	e8 89 da ff ff       	call   80101ab0 <iput>
  end_op();
80104027:	e8 94 ef ff ff       	call   80102fc0 <end_op>
  curproc->cwd = 0;
8010402c:	c7 46 68 00 00 00 00 	movl   $0x0,0x68(%esi)
  acquire(&ptable.lock);
80104033:	c7 04 24 40 2d 11 80 	movl   $0x80112d40,(%esp)
8010403a:	e8 51 07 00 00       	call   80104790 <acquire>
  wakeup1(curproc->parent);
8010403f:	8b 56 14             	mov    0x14(%esi),%edx
80104042:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104045:	b8 74 2d 11 80       	mov    $0x80112d74,%eax
8010404a:	eb 0e                	jmp    8010405a <exit+0x9a>
8010404c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104050:	83 e8 80             	sub    $0xffffff80,%eax
80104053:	3d 74 4d 11 80       	cmp    $0x80114d74,%eax
80104058:	74 1c                	je     80104076 <exit+0xb6>
    if(p->state == SLEEPING && p->chan == chan)
8010405a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
8010405e:	75 f0                	jne    80104050 <exit+0x90>
80104060:	3b 50 20             	cmp    0x20(%eax),%edx
80104063:	75 eb                	jne    80104050 <exit+0x90>
      p->state = RUNNABLE;
80104065:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010406c:	83 e8 80             	sub    $0xffffff80,%eax
8010406f:	3d 74 4d 11 80       	cmp    $0x80114d74,%eax
80104074:	75 e4                	jne    8010405a <exit+0x9a>
      p->parent = initproc;
80104076:	8b 0d d8 a5 10 80    	mov    0x8010a5d8,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010407c:	ba 74 2d 11 80       	mov    $0x80112d74,%edx
80104081:	eb 10                	jmp    80104093 <exit+0xd3>
80104083:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104087:	90                   	nop
80104088:	83 ea 80             	sub    $0xffffff80,%edx
8010408b:	81 fa 74 4d 11 80    	cmp    $0x80114d74,%edx
80104091:	74 3b                	je     801040ce <exit+0x10e>
    if(p->parent == curproc){
80104093:	39 72 14             	cmp    %esi,0x14(%edx)
80104096:	75 f0                	jne    80104088 <exit+0xc8>
      if(p->state == ZOMBIE)
80104098:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
8010409c:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
8010409f:	75 e7                	jne    80104088 <exit+0xc8>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801040a1:	b8 74 2d 11 80       	mov    $0x80112d74,%eax
801040a6:	eb 12                	jmp    801040ba <exit+0xfa>
801040a8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801040af:	90                   	nop
801040b0:	83 e8 80             	sub    $0xffffff80,%eax
801040b3:	3d 74 4d 11 80       	cmp    $0x80114d74,%eax
801040b8:	74 ce                	je     80104088 <exit+0xc8>
    if(p->state == SLEEPING && p->chan == chan)
801040ba:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801040be:	75 f0                	jne    801040b0 <exit+0xf0>
801040c0:	3b 48 20             	cmp    0x20(%eax),%ecx
801040c3:	75 eb                	jne    801040b0 <exit+0xf0>
      p->state = RUNNABLE;
801040c5:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
801040cc:	eb e2                	jmp    801040b0 <exit+0xf0>
  curproc->state = ZOMBIE;
801040ce:	c7 46 0c 05 00 00 00 	movl   $0x5,0xc(%esi)
  sched();
801040d5:	e8 26 fe ff ff       	call   80103f00 <sched>
  panic("zombie exit");
801040da:	83 ec 0c             	sub    $0xc,%esp
801040dd:	68 48 79 10 80       	push   $0x80107948
801040e2:	e8 a9 c2 ff ff       	call   80100390 <panic>
    panic("init exiting");
801040e7:	83 ec 0c             	sub    $0xc,%esp
801040ea:	68 3b 79 10 80       	push   $0x8010793b
801040ef:	e8 9c c2 ff ff       	call   80100390 <panic>
801040f4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801040fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801040ff:	90                   	nop

80104100 <yield>:
{
80104100:	f3 0f 1e fb          	endbr32 
80104104:	55                   	push   %ebp
80104105:	89 e5                	mov    %esp,%ebp
80104107:	53                   	push   %ebx
80104108:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
8010410b:	68 40 2d 11 80       	push   $0x80112d40
80104110:	e8 7b 06 00 00       	call   80104790 <acquire>
  pushcli();
80104115:	e8 76 05 00 00       	call   80104690 <pushcli>
  c = mycpu();
8010411a:	e8 e1 f9 ff ff       	call   80103b00 <mycpu>
  p = c->proc;
8010411f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104125:	e8 b6 05 00 00       	call   801046e0 <popcli>
  myproc()->state = RUNNABLE;
8010412a:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
80104131:	e8 ca fd ff ff       	call   80103f00 <sched>
  release(&ptable.lock);
80104136:	c7 04 24 40 2d 11 80 	movl   $0x80112d40,(%esp)
8010413d:	e8 0e 07 00 00       	call   80104850 <release>
}
80104142:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104145:	83 c4 10             	add    $0x10,%esp
80104148:	c9                   	leave  
80104149:	c3                   	ret    
8010414a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104150 <sleep>:
{
80104150:	f3 0f 1e fb          	endbr32 
80104154:	55                   	push   %ebp
80104155:	89 e5                	mov    %esp,%ebp
80104157:	57                   	push   %edi
80104158:	56                   	push   %esi
80104159:	53                   	push   %ebx
8010415a:	83 ec 0c             	sub    $0xc,%esp
8010415d:	8b 7d 08             	mov    0x8(%ebp),%edi
80104160:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
80104163:	e8 28 05 00 00       	call   80104690 <pushcli>
  c = mycpu();
80104168:	e8 93 f9 ff ff       	call   80103b00 <mycpu>
  p = c->proc;
8010416d:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104173:	e8 68 05 00 00       	call   801046e0 <popcli>
  if(p == 0)
80104178:	85 db                	test   %ebx,%ebx
8010417a:	0f 84 83 00 00 00    	je     80104203 <sleep+0xb3>
  if(lk == 0)
80104180:	85 f6                	test   %esi,%esi
80104182:	74 72                	je     801041f6 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80104184:	81 fe 40 2d 11 80    	cmp    $0x80112d40,%esi
8010418a:	74 4c                	je     801041d8 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
8010418c:	83 ec 0c             	sub    $0xc,%esp
8010418f:	68 40 2d 11 80       	push   $0x80112d40
80104194:	e8 f7 05 00 00       	call   80104790 <acquire>
    release(lk);
80104199:	89 34 24             	mov    %esi,(%esp)
8010419c:	e8 af 06 00 00       	call   80104850 <release>
  p->chan = chan;
801041a1:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
801041a4:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
801041ab:	e8 50 fd ff ff       	call   80103f00 <sched>
  p->chan = 0;
801041b0:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
801041b7:	c7 04 24 40 2d 11 80 	movl   $0x80112d40,(%esp)
801041be:	e8 8d 06 00 00       	call   80104850 <release>
    acquire(lk);
801041c3:	89 75 08             	mov    %esi,0x8(%ebp)
801041c6:	83 c4 10             	add    $0x10,%esp
}
801041c9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801041cc:	5b                   	pop    %ebx
801041cd:	5e                   	pop    %esi
801041ce:	5f                   	pop    %edi
801041cf:	5d                   	pop    %ebp
    acquire(lk);
801041d0:	e9 bb 05 00 00       	jmp    80104790 <acquire>
801041d5:	8d 76 00             	lea    0x0(%esi),%esi
  p->chan = chan;
801041d8:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
801041db:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
801041e2:	e8 19 fd ff ff       	call   80103f00 <sched>
  p->chan = 0;
801041e7:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
801041ee:	8d 65 f4             	lea    -0xc(%ebp),%esp
801041f1:	5b                   	pop    %ebx
801041f2:	5e                   	pop    %esi
801041f3:	5f                   	pop    %edi
801041f4:	5d                   	pop    %ebp
801041f5:	c3                   	ret    
    panic("sleep without lk");
801041f6:	83 ec 0c             	sub    $0xc,%esp
801041f9:	68 5a 79 10 80       	push   $0x8010795a
801041fe:	e8 8d c1 ff ff       	call   80100390 <panic>
    panic("sleep");
80104203:	83 ec 0c             	sub    $0xc,%esp
80104206:	68 54 79 10 80       	push   $0x80107954
8010420b:	e8 80 c1 ff ff       	call   80100390 <panic>

80104210 <wait>:
{
80104210:	f3 0f 1e fb          	endbr32 
80104214:	55                   	push   %ebp
80104215:	89 e5                	mov    %esp,%ebp
80104217:	56                   	push   %esi
80104218:	53                   	push   %ebx
  pushcli();
80104219:	e8 72 04 00 00       	call   80104690 <pushcli>
  c = mycpu();
8010421e:	e8 dd f8 ff ff       	call   80103b00 <mycpu>
  p = c->proc;
80104223:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104229:	e8 b2 04 00 00       	call   801046e0 <popcli>
  acquire(&ptable.lock);
8010422e:	83 ec 0c             	sub    $0xc,%esp
80104231:	68 40 2d 11 80       	push   $0x80112d40
80104236:	e8 55 05 00 00       	call   80104790 <acquire>
8010423b:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
8010423e:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104240:	bb 74 2d 11 80       	mov    $0x80112d74,%ebx
80104245:	eb 14                	jmp    8010425b <wait+0x4b>
80104247:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010424e:	66 90                	xchg   %ax,%ax
80104250:	83 eb 80             	sub    $0xffffff80,%ebx
80104253:	81 fb 74 4d 11 80    	cmp    $0x80114d74,%ebx
80104259:	74 1b                	je     80104276 <wait+0x66>
      if(p->parent != curproc)
8010425b:	39 73 14             	cmp    %esi,0x14(%ebx)
8010425e:	75 f0                	jne    80104250 <wait+0x40>
      if(p->state == ZOMBIE){
80104260:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80104264:	74 32                	je     80104298 <wait+0x88>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104266:	83 eb 80             	sub    $0xffffff80,%ebx
      havekids = 1;
80104269:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010426e:	81 fb 74 4d 11 80    	cmp    $0x80114d74,%ebx
80104274:	75 e5                	jne    8010425b <wait+0x4b>
    if(!havekids || curproc->killed){
80104276:	85 c0                	test   %eax,%eax
80104278:	74 74                	je     801042ee <wait+0xde>
8010427a:	8b 46 24             	mov    0x24(%esi),%eax
8010427d:	85 c0                	test   %eax,%eax
8010427f:	75 6d                	jne    801042ee <wait+0xde>
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
80104281:	83 ec 08             	sub    $0x8,%esp
80104284:	68 40 2d 11 80       	push   $0x80112d40
80104289:	56                   	push   %esi
8010428a:	e8 c1 fe ff ff       	call   80104150 <sleep>
    havekids = 0;
8010428f:	83 c4 10             	add    $0x10,%esp
80104292:	eb aa                	jmp    8010423e <wait+0x2e>
80104294:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        kfree(p->kstack);
80104298:	83 ec 0c             	sub    $0xc,%esp
8010429b:	ff 73 08             	pushl  0x8(%ebx)
        pid = p->pid;
8010429e:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
801042a1:	e8 ea e3 ff ff       	call   80102690 <kfree>
        freevm(p->pgdir);
801042a6:	5a                   	pop    %edx
801042a7:	ff 73 04             	pushl  0x4(%ebx)
        p->kstack = 0;
801042aa:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
801042b1:	e8 aa 2d 00 00       	call   80107060 <freevm>
        release(&ptable.lock);
801042b6:	c7 04 24 40 2d 11 80 	movl   $0x80112d40,(%esp)
        p->pid = 0;
801042bd:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
801042c4:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
801042cb:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
801042cf:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
801042d6:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
801042dd:	e8 6e 05 00 00       	call   80104850 <release>
        return pid;
801042e2:	83 c4 10             	add    $0x10,%esp
}
801042e5:	8d 65 f8             	lea    -0x8(%ebp),%esp
801042e8:	89 f0                	mov    %esi,%eax
801042ea:	5b                   	pop    %ebx
801042eb:	5e                   	pop    %esi
801042ec:	5d                   	pop    %ebp
801042ed:	c3                   	ret    
      release(&ptable.lock);
801042ee:	83 ec 0c             	sub    $0xc,%esp
      return -1;
801042f1:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
801042f6:	68 40 2d 11 80       	push   $0x80112d40
801042fb:	e8 50 05 00 00       	call   80104850 <release>
      return -1;
80104300:	83 c4 10             	add    $0x10,%esp
80104303:	eb e0                	jmp    801042e5 <wait+0xd5>
80104305:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010430c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104310 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104310:	f3 0f 1e fb          	endbr32 
80104314:	55                   	push   %ebp
80104315:	89 e5                	mov    %esp,%ebp
80104317:	53                   	push   %ebx
80104318:	83 ec 10             	sub    $0x10,%esp
8010431b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
8010431e:	68 40 2d 11 80       	push   $0x80112d40
80104323:	e8 68 04 00 00       	call   80104790 <acquire>
80104328:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010432b:	b8 74 2d 11 80       	mov    $0x80112d74,%eax
80104330:	eb 10                	jmp    80104342 <wakeup+0x32>
80104332:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104338:	83 e8 80             	sub    $0xffffff80,%eax
8010433b:	3d 74 4d 11 80       	cmp    $0x80114d74,%eax
80104340:	74 1c                	je     8010435e <wakeup+0x4e>
    if(p->state == SLEEPING && p->chan == chan)
80104342:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104346:	75 f0                	jne    80104338 <wakeup+0x28>
80104348:	3b 58 20             	cmp    0x20(%eax),%ebx
8010434b:	75 eb                	jne    80104338 <wakeup+0x28>
      p->state = RUNNABLE;
8010434d:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104354:	83 e8 80             	sub    $0xffffff80,%eax
80104357:	3d 74 4d 11 80       	cmp    $0x80114d74,%eax
8010435c:	75 e4                	jne    80104342 <wakeup+0x32>
  wakeup1(chan);
  release(&ptable.lock);
8010435e:	c7 45 08 40 2d 11 80 	movl   $0x80112d40,0x8(%ebp)
}
80104365:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104368:	c9                   	leave  
  release(&ptable.lock);
80104369:	e9 e2 04 00 00       	jmp    80104850 <release>
8010436e:	66 90                	xchg   %ax,%ax

80104370 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104370:	f3 0f 1e fb          	endbr32 
80104374:	55                   	push   %ebp
80104375:	89 e5                	mov    %esp,%ebp
80104377:	53                   	push   %ebx
80104378:	83 ec 10             	sub    $0x10,%esp
8010437b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
8010437e:	68 40 2d 11 80       	push   $0x80112d40
80104383:	e8 08 04 00 00       	call   80104790 <acquire>
80104388:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010438b:	b8 74 2d 11 80       	mov    $0x80112d74,%eax
80104390:	eb 10                	jmp    801043a2 <kill+0x32>
80104392:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104398:	83 e8 80             	sub    $0xffffff80,%eax
8010439b:	3d 74 4d 11 80       	cmp    $0x80114d74,%eax
801043a0:	74 36                	je     801043d8 <kill+0x68>
    if(p->pid == pid){
801043a2:	39 58 10             	cmp    %ebx,0x10(%eax)
801043a5:	75 f1                	jne    80104398 <kill+0x28>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
801043a7:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
801043ab:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
801043b2:	75 07                	jne    801043bb <kill+0x4b>
        p->state = RUNNABLE;
801043b4:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
801043bb:	83 ec 0c             	sub    $0xc,%esp
801043be:	68 40 2d 11 80       	push   $0x80112d40
801043c3:	e8 88 04 00 00       	call   80104850 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
801043c8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return 0;
801043cb:	83 c4 10             	add    $0x10,%esp
801043ce:	31 c0                	xor    %eax,%eax
}
801043d0:	c9                   	leave  
801043d1:	c3                   	ret    
801043d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  release(&ptable.lock);
801043d8:	83 ec 0c             	sub    $0xc,%esp
801043db:	68 40 2d 11 80       	push   $0x80112d40
801043e0:	e8 6b 04 00 00       	call   80104850 <release>
}
801043e5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
801043e8:	83 c4 10             	add    $0x10,%esp
801043eb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801043f0:	c9                   	leave  
801043f1:	c3                   	ret    
801043f2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801043f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104400 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104400:	f3 0f 1e fb          	endbr32 
80104404:	55                   	push   %ebp
80104405:	89 e5                	mov    %esp,%ebp
80104407:	57                   	push   %edi
80104408:	56                   	push   %esi
80104409:	8d 75 e8             	lea    -0x18(%ebp),%esi
8010440c:	53                   	push   %ebx
8010440d:	bb e0 2d 11 80       	mov    $0x80112de0,%ebx
80104412:	83 ec 3c             	sub    $0x3c,%esp
80104415:	eb 28                	jmp    8010443f <procdump+0x3f>
80104417:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010441e:	66 90                	xchg   %ax,%ax
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104420:	83 ec 0c             	sub    $0xc,%esp
80104423:	68 df 7c 10 80       	push   $0x80107cdf
80104428:	e8 f3 c2 ff ff       	call   80100720 <cprintf>
8010442d:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104430:	83 eb 80             	sub    $0xffffff80,%ebx
80104433:	81 fb e0 4d 11 80    	cmp    $0x80114de0,%ebx
80104439:	0f 84 81 00 00 00    	je     801044c0 <procdump+0xc0>
    if(p->state == UNUSED)
8010443f:	8b 43 a0             	mov    -0x60(%ebx),%eax
80104442:	85 c0                	test   %eax,%eax
80104444:	74 ea                	je     80104430 <procdump+0x30>
      state = "???";
80104446:	ba 6b 79 10 80       	mov    $0x8010796b,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
8010444b:	83 f8 05             	cmp    $0x5,%eax
8010444e:	77 11                	ja     80104461 <procdump+0x61>
80104450:	8b 14 85 cc 79 10 80 	mov    -0x7fef8634(,%eax,4),%edx
      state = "???";
80104457:	b8 6b 79 10 80       	mov    $0x8010796b,%eax
8010445c:	85 d2                	test   %edx,%edx
8010445e:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
80104461:	53                   	push   %ebx
80104462:	52                   	push   %edx
80104463:	ff 73 a4             	pushl  -0x5c(%ebx)
80104466:	68 6f 79 10 80       	push   $0x8010796f
8010446b:	e8 b0 c2 ff ff       	call   80100720 <cprintf>
    if(p->state == SLEEPING){
80104470:	83 c4 10             	add    $0x10,%esp
80104473:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
80104477:	75 a7                	jne    80104420 <procdump+0x20>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104479:	83 ec 08             	sub    $0x8,%esp
8010447c:	8d 45 c0             	lea    -0x40(%ebp),%eax
8010447f:	8d 7d c0             	lea    -0x40(%ebp),%edi
80104482:	50                   	push   %eax
80104483:	8b 43 b0             	mov    -0x50(%ebx),%eax
80104486:	8b 40 0c             	mov    0xc(%eax),%eax
80104489:	83 c0 08             	add    $0x8,%eax
8010448c:	50                   	push   %eax
8010448d:	e8 9e 01 00 00       	call   80104630 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
80104492:	83 c4 10             	add    $0x10,%esp
80104495:	8d 76 00             	lea    0x0(%esi),%esi
80104498:	8b 17                	mov    (%edi),%edx
8010449a:	85 d2                	test   %edx,%edx
8010449c:	74 82                	je     80104420 <procdump+0x20>
        cprintf(" %p", pc[i]);
8010449e:	83 ec 08             	sub    $0x8,%esp
801044a1:	83 c7 04             	add    $0x4,%edi
801044a4:	52                   	push   %edx
801044a5:	68 c1 73 10 80       	push   $0x801073c1
801044aa:	e8 71 c2 ff ff       	call   80100720 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
801044af:	83 c4 10             	add    $0x10,%esp
801044b2:	39 fe                	cmp    %edi,%esi
801044b4:	75 e2                	jne    80104498 <procdump+0x98>
801044b6:	e9 65 ff ff ff       	jmp    80104420 <procdump+0x20>
801044bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801044bf:	90                   	nop
  }
}
801044c0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801044c3:	5b                   	pop    %ebx
801044c4:	5e                   	pop    %esi
801044c5:	5f                   	pop    %edi
801044c6:	5d                   	pop    %ebp
801044c7:	c3                   	ret    
801044c8:	66 90                	xchg   %ax,%ax
801044ca:	66 90                	xchg   %ax,%ax
801044cc:	66 90                	xchg   %ax,%ax
801044ce:	66 90                	xchg   %ax,%ax

801044d0 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
801044d0:	f3 0f 1e fb          	endbr32 
801044d4:	55                   	push   %ebp
801044d5:	89 e5                	mov    %esp,%ebp
801044d7:	53                   	push   %ebx
801044d8:	83 ec 0c             	sub    $0xc,%esp
801044db:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
801044de:	68 e4 79 10 80       	push   $0x801079e4
801044e3:	8d 43 04             	lea    0x4(%ebx),%eax
801044e6:	50                   	push   %eax
801044e7:	e8 24 01 00 00       	call   80104610 <initlock>
  lk->name = name;
801044ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
801044ef:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
801044f5:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
801044f8:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
801044ff:	89 43 38             	mov    %eax,0x38(%ebx)
}
80104502:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104505:	c9                   	leave  
80104506:	c3                   	ret    
80104507:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010450e:	66 90                	xchg   %ax,%ax

80104510 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104510:	f3 0f 1e fb          	endbr32 
80104514:	55                   	push   %ebp
80104515:	89 e5                	mov    %esp,%ebp
80104517:	56                   	push   %esi
80104518:	53                   	push   %ebx
80104519:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
8010451c:	8d 73 04             	lea    0x4(%ebx),%esi
8010451f:	83 ec 0c             	sub    $0xc,%esp
80104522:	56                   	push   %esi
80104523:	e8 68 02 00 00       	call   80104790 <acquire>
  while (lk->locked) {
80104528:	8b 13                	mov    (%ebx),%edx
8010452a:	83 c4 10             	add    $0x10,%esp
8010452d:	85 d2                	test   %edx,%edx
8010452f:	74 1a                	je     8010454b <acquiresleep+0x3b>
80104531:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sleep(lk, &lk->lk);
80104538:	83 ec 08             	sub    $0x8,%esp
8010453b:	56                   	push   %esi
8010453c:	53                   	push   %ebx
8010453d:	e8 0e fc ff ff       	call   80104150 <sleep>
  while (lk->locked) {
80104542:	8b 03                	mov    (%ebx),%eax
80104544:	83 c4 10             	add    $0x10,%esp
80104547:	85 c0                	test   %eax,%eax
80104549:	75 ed                	jne    80104538 <acquiresleep+0x28>
  }
  lk->locked = 1;
8010454b:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104551:	e8 3a f6 ff ff       	call   80103b90 <myproc>
80104556:	8b 40 10             	mov    0x10(%eax),%eax
80104559:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
8010455c:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010455f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104562:	5b                   	pop    %ebx
80104563:	5e                   	pop    %esi
80104564:	5d                   	pop    %ebp
  release(&lk->lk);
80104565:	e9 e6 02 00 00       	jmp    80104850 <release>
8010456a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104570 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104570:	f3 0f 1e fb          	endbr32 
80104574:	55                   	push   %ebp
80104575:	89 e5                	mov    %esp,%ebp
80104577:	56                   	push   %esi
80104578:	53                   	push   %ebx
80104579:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
8010457c:	8d 73 04             	lea    0x4(%ebx),%esi
8010457f:	83 ec 0c             	sub    $0xc,%esp
80104582:	56                   	push   %esi
80104583:	e8 08 02 00 00       	call   80104790 <acquire>
  lk->locked = 0;
80104588:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
8010458e:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104595:	89 1c 24             	mov    %ebx,(%esp)
80104598:	e8 73 fd ff ff       	call   80104310 <wakeup>
  release(&lk->lk);
8010459d:	89 75 08             	mov    %esi,0x8(%ebp)
801045a0:	83 c4 10             	add    $0x10,%esp
}
801045a3:	8d 65 f8             	lea    -0x8(%ebp),%esp
801045a6:	5b                   	pop    %ebx
801045a7:	5e                   	pop    %esi
801045a8:	5d                   	pop    %ebp
  release(&lk->lk);
801045a9:	e9 a2 02 00 00       	jmp    80104850 <release>
801045ae:	66 90                	xchg   %ax,%ax

801045b0 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
801045b0:	f3 0f 1e fb          	endbr32 
801045b4:	55                   	push   %ebp
801045b5:	89 e5                	mov    %esp,%ebp
801045b7:	57                   	push   %edi
801045b8:	31 ff                	xor    %edi,%edi
801045ba:	56                   	push   %esi
801045bb:	53                   	push   %ebx
801045bc:	83 ec 18             	sub    $0x18,%esp
801045bf:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
801045c2:	8d 73 04             	lea    0x4(%ebx),%esi
801045c5:	56                   	push   %esi
801045c6:	e8 c5 01 00 00       	call   80104790 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
801045cb:	8b 03                	mov    (%ebx),%eax
801045cd:	83 c4 10             	add    $0x10,%esp
801045d0:	85 c0                	test   %eax,%eax
801045d2:	75 1c                	jne    801045f0 <holdingsleep+0x40>
  release(&lk->lk);
801045d4:	83 ec 0c             	sub    $0xc,%esp
801045d7:	56                   	push   %esi
801045d8:	e8 73 02 00 00       	call   80104850 <release>
  return r;
}
801045dd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801045e0:	89 f8                	mov    %edi,%eax
801045e2:	5b                   	pop    %ebx
801045e3:	5e                   	pop    %esi
801045e4:	5f                   	pop    %edi
801045e5:	5d                   	pop    %ebp
801045e6:	c3                   	ret    
801045e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801045ee:	66 90                	xchg   %ax,%ax
  r = lk->locked && (lk->pid == myproc()->pid);
801045f0:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
801045f3:	e8 98 f5 ff ff       	call   80103b90 <myproc>
801045f8:	39 58 10             	cmp    %ebx,0x10(%eax)
801045fb:	0f 94 c0             	sete   %al
801045fe:	0f b6 c0             	movzbl %al,%eax
80104601:	89 c7                	mov    %eax,%edi
80104603:	eb cf                	jmp    801045d4 <holdingsleep+0x24>
80104605:	66 90                	xchg   %ax,%ax
80104607:	66 90                	xchg   %ax,%ax
80104609:	66 90                	xchg   %ax,%ax
8010460b:	66 90                	xchg   %ax,%ax
8010460d:	66 90                	xchg   %ax,%ax
8010460f:	90                   	nop

80104610 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104610:	f3 0f 1e fb          	endbr32 
80104614:	55                   	push   %ebp
80104615:	89 e5                	mov    %esp,%ebp
80104617:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
8010461a:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
8010461d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
80104623:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104626:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
8010462d:	5d                   	pop    %ebp
8010462e:	c3                   	ret    
8010462f:	90                   	nop

80104630 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104630:	f3 0f 1e fb          	endbr32 
80104634:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104635:	31 d2                	xor    %edx,%edx
{
80104637:	89 e5                	mov    %esp,%ebp
80104639:	53                   	push   %ebx
  ebp = (uint*)v - 2;
8010463a:	8b 45 08             	mov    0x8(%ebp),%eax
{
8010463d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
80104640:	83 e8 08             	sub    $0x8,%eax
  for(i = 0; i < 10; i++){
80104643:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104647:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104648:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
8010464e:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104654:	77 1a                	ja     80104670 <getcallerpcs+0x40>
      break;
    pcs[i] = ebp[1];     // saved %eip
80104656:	8b 58 04             	mov    0x4(%eax),%ebx
80104659:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
8010465c:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
8010465f:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104661:	83 fa 0a             	cmp    $0xa,%edx
80104664:	75 e2                	jne    80104648 <getcallerpcs+0x18>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
80104666:	5b                   	pop    %ebx
80104667:	5d                   	pop    %ebp
80104668:	c3                   	ret    
80104669:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(; i < 10; i++)
80104670:	8d 04 91             	lea    (%ecx,%edx,4),%eax
80104673:	8d 51 28             	lea    0x28(%ecx),%edx
80104676:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010467d:	8d 76 00             	lea    0x0(%esi),%esi
    pcs[i] = 0;
80104680:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104686:	83 c0 04             	add    $0x4,%eax
80104689:	39 d0                	cmp    %edx,%eax
8010468b:	75 f3                	jne    80104680 <getcallerpcs+0x50>
}
8010468d:	5b                   	pop    %ebx
8010468e:	5d                   	pop    %ebp
8010468f:	c3                   	ret    

80104690 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104690:	f3 0f 1e fb          	endbr32 
80104694:	55                   	push   %ebp
80104695:	89 e5                	mov    %esp,%ebp
80104697:	53                   	push   %ebx
80104698:	83 ec 04             	sub    $0x4,%esp
8010469b:	9c                   	pushf  
8010469c:	5b                   	pop    %ebx
  asm volatile("cli");
8010469d:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
8010469e:	e8 5d f4 ff ff       	call   80103b00 <mycpu>
801046a3:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
801046a9:	85 c0                	test   %eax,%eax
801046ab:	74 13                	je     801046c0 <pushcli+0x30>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
801046ad:	e8 4e f4 ff ff       	call   80103b00 <mycpu>
801046b2:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
801046b9:	83 c4 04             	add    $0x4,%esp
801046bc:	5b                   	pop    %ebx
801046bd:	5d                   	pop    %ebp
801046be:	c3                   	ret    
801046bf:	90                   	nop
    mycpu()->intena = eflags & FL_IF;
801046c0:	e8 3b f4 ff ff       	call   80103b00 <mycpu>
801046c5:	81 e3 00 02 00 00    	and    $0x200,%ebx
801046cb:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
801046d1:	eb da                	jmp    801046ad <pushcli+0x1d>
801046d3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801046da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801046e0 <popcli>:

void
popcli(void)
{
801046e0:	f3 0f 1e fb          	endbr32 
801046e4:	55                   	push   %ebp
801046e5:	89 e5                	mov    %esp,%ebp
801046e7:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801046ea:	9c                   	pushf  
801046eb:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801046ec:	f6 c4 02             	test   $0x2,%ah
801046ef:	75 31                	jne    80104722 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
801046f1:	e8 0a f4 ff ff       	call   80103b00 <mycpu>
801046f6:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
801046fd:	78 30                	js     8010472f <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
801046ff:	e8 fc f3 ff ff       	call   80103b00 <mycpu>
80104704:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
8010470a:	85 d2                	test   %edx,%edx
8010470c:	74 02                	je     80104710 <popcli+0x30>
    sti();
}
8010470e:	c9                   	leave  
8010470f:	c3                   	ret    
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104710:	e8 eb f3 ff ff       	call   80103b00 <mycpu>
80104715:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
8010471b:	85 c0                	test   %eax,%eax
8010471d:	74 ef                	je     8010470e <popcli+0x2e>
  asm volatile("sti");
8010471f:	fb                   	sti    
}
80104720:	c9                   	leave  
80104721:	c3                   	ret    
    panic("popcli - interruptible");
80104722:	83 ec 0c             	sub    $0xc,%esp
80104725:	68 ef 79 10 80       	push   $0x801079ef
8010472a:	e8 61 bc ff ff       	call   80100390 <panic>
    panic("popcli");
8010472f:	83 ec 0c             	sub    $0xc,%esp
80104732:	68 06 7a 10 80       	push   $0x80107a06
80104737:	e8 54 bc ff ff       	call   80100390 <panic>
8010473c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104740 <holding>:
{
80104740:	f3 0f 1e fb          	endbr32 
80104744:	55                   	push   %ebp
80104745:	89 e5                	mov    %esp,%ebp
80104747:	56                   	push   %esi
80104748:	53                   	push   %ebx
80104749:	8b 75 08             	mov    0x8(%ebp),%esi
8010474c:	31 db                	xor    %ebx,%ebx
  pushcli();
8010474e:	e8 3d ff ff ff       	call   80104690 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104753:	8b 06                	mov    (%esi),%eax
80104755:	85 c0                	test   %eax,%eax
80104757:	75 0f                	jne    80104768 <holding+0x28>
  popcli();
80104759:	e8 82 ff ff ff       	call   801046e0 <popcli>
}
8010475e:	89 d8                	mov    %ebx,%eax
80104760:	5b                   	pop    %ebx
80104761:	5e                   	pop    %esi
80104762:	5d                   	pop    %ebp
80104763:	c3                   	ret    
80104764:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  r = lock->locked && lock->cpu == mycpu();
80104768:	8b 5e 08             	mov    0x8(%esi),%ebx
8010476b:	e8 90 f3 ff ff       	call   80103b00 <mycpu>
80104770:	39 c3                	cmp    %eax,%ebx
80104772:	0f 94 c3             	sete   %bl
  popcli();
80104775:	e8 66 ff ff ff       	call   801046e0 <popcli>
  r = lock->locked && lock->cpu == mycpu();
8010477a:	0f b6 db             	movzbl %bl,%ebx
}
8010477d:	89 d8                	mov    %ebx,%eax
8010477f:	5b                   	pop    %ebx
80104780:	5e                   	pop    %esi
80104781:	5d                   	pop    %ebp
80104782:	c3                   	ret    
80104783:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010478a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104790 <acquire>:
{
80104790:	f3 0f 1e fb          	endbr32 
80104794:	55                   	push   %ebp
80104795:	89 e5                	mov    %esp,%ebp
80104797:	56                   	push   %esi
80104798:	53                   	push   %ebx
  pushcli(); // disable interrupts to avoid deadlock.
80104799:	e8 f2 fe ff ff       	call   80104690 <pushcli>
  if(holding(lk))
8010479e:	8b 5d 08             	mov    0x8(%ebp),%ebx
801047a1:	83 ec 0c             	sub    $0xc,%esp
801047a4:	53                   	push   %ebx
801047a5:	e8 96 ff ff ff       	call   80104740 <holding>
801047aa:	83 c4 10             	add    $0x10,%esp
801047ad:	85 c0                	test   %eax,%eax
801047af:	0f 85 7f 00 00 00    	jne    80104834 <acquire+0xa4>
801047b5:	89 c6                	mov    %eax,%esi
  asm volatile("lock; xchgl %0, %1" :
801047b7:	ba 01 00 00 00       	mov    $0x1,%edx
801047bc:	eb 05                	jmp    801047c3 <acquire+0x33>
801047be:	66 90                	xchg   %ax,%ax
801047c0:	8b 5d 08             	mov    0x8(%ebp),%ebx
801047c3:	89 d0                	mov    %edx,%eax
801047c5:	f0 87 03             	lock xchg %eax,(%ebx)
  while(xchg(&lk->locked, 1) != 0)
801047c8:	85 c0                	test   %eax,%eax
801047ca:	75 f4                	jne    801047c0 <acquire+0x30>
  __sync_synchronize();
801047cc:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
801047d1:	8b 5d 08             	mov    0x8(%ebp),%ebx
801047d4:	e8 27 f3 ff ff       	call   80103b00 <mycpu>
801047d9:	89 43 08             	mov    %eax,0x8(%ebx)
  ebp = (uint*)v - 2;
801047dc:	89 e8                	mov    %ebp,%eax
801047de:	66 90                	xchg   %ax,%ax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801047e0:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
801047e6:	81 fa fe ff ff 7f    	cmp    $0x7ffffffe,%edx
801047ec:	77 22                	ja     80104810 <acquire+0x80>
    pcs[i] = ebp[1];     // saved %eip
801047ee:	8b 50 04             	mov    0x4(%eax),%edx
801047f1:	89 54 b3 0c          	mov    %edx,0xc(%ebx,%esi,4)
  for(i = 0; i < 10; i++){
801047f5:	83 c6 01             	add    $0x1,%esi
    ebp = (uint*)ebp[0]; // saved %ebp
801047f8:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
801047fa:	83 fe 0a             	cmp    $0xa,%esi
801047fd:	75 e1                	jne    801047e0 <acquire+0x50>
}
801047ff:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104802:	5b                   	pop    %ebx
80104803:	5e                   	pop    %esi
80104804:	5d                   	pop    %ebp
80104805:	c3                   	ret    
80104806:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010480d:	8d 76 00             	lea    0x0(%esi),%esi
  for(; i < 10; i++)
80104810:	8d 44 b3 0c          	lea    0xc(%ebx,%esi,4),%eax
80104814:	83 c3 34             	add    $0x34,%ebx
80104817:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010481e:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80104820:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104826:	83 c0 04             	add    $0x4,%eax
80104829:	39 d8                	cmp    %ebx,%eax
8010482b:	75 f3                	jne    80104820 <acquire+0x90>
}
8010482d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104830:	5b                   	pop    %ebx
80104831:	5e                   	pop    %esi
80104832:	5d                   	pop    %ebp
80104833:	c3                   	ret    
    panic("acquire");
80104834:	83 ec 0c             	sub    $0xc,%esp
80104837:	68 0d 7a 10 80       	push   $0x80107a0d
8010483c:	e8 4f bb ff ff       	call   80100390 <panic>
80104841:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104848:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010484f:	90                   	nop

80104850 <release>:
{
80104850:	f3 0f 1e fb          	endbr32 
80104854:	55                   	push   %ebp
80104855:	89 e5                	mov    %esp,%ebp
80104857:	53                   	push   %ebx
80104858:	83 ec 10             	sub    $0x10,%esp
8010485b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
8010485e:	53                   	push   %ebx
8010485f:	e8 dc fe ff ff       	call   80104740 <holding>
80104864:	83 c4 10             	add    $0x10,%esp
80104867:	85 c0                	test   %eax,%eax
80104869:	74 22                	je     8010488d <release+0x3d>
  lk->pcs[0] = 0;
8010486b:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80104872:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80104879:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
8010487e:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80104884:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104887:	c9                   	leave  
  popcli();
80104888:	e9 53 fe ff ff       	jmp    801046e0 <popcli>
    panic("release");
8010488d:	83 ec 0c             	sub    $0xc,%esp
80104890:	68 15 7a 10 80       	push   $0x80107a15
80104895:	e8 f6 ba ff ff       	call   80100390 <panic>
8010489a:	66 90                	xchg   %ax,%ax
8010489c:	66 90                	xchg   %ax,%ax
8010489e:	66 90                	xchg   %ax,%ax

801048a0 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
801048a0:	f3 0f 1e fb          	endbr32 
801048a4:	55                   	push   %ebp
801048a5:	89 e5                	mov    %esp,%ebp
801048a7:	57                   	push   %edi
801048a8:	8b 55 08             	mov    0x8(%ebp),%edx
801048ab:	8b 4d 10             	mov    0x10(%ebp),%ecx
801048ae:	53                   	push   %ebx
801048af:	8b 45 0c             	mov    0xc(%ebp),%eax
  if ((int)dst%4 == 0 && n%4 == 0){
801048b2:	89 d7                	mov    %edx,%edi
801048b4:	09 cf                	or     %ecx,%edi
801048b6:	83 e7 03             	and    $0x3,%edi
801048b9:	75 25                	jne    801048e0 <memset+0x40>
    c &= 0xFF;
801048bb:	0f b6 f8             	movzbl %al,%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
801048be:	c1 e0 18             	shl    $0x18,%eax
801048c1:	89 fb                	mov    %edi,%ebx
801048c3:	c1 e9 02             	shr    $0x2,%ecx
801048c6:	c1 e3 10             	shl    $0x10,%ebx
801048c9:	09 d8                	or     %ebx,%eax
801048cb:	09 f8                	or     %edi,%eax
801048cd:	c1 e7 08             	shl    $0x8,%edi
801048d0:	09 f8                	or     %edi,%eax
}

static inline void
stosl(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosl" :
801048d2:	89 d7                	mov    %edx,%edi
801048d4:	fc                   	cld    
801048d5:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
801048d7:	5b                   	pop    %ebx
801048d8:	89 d0                	mov    %edx,%eax
801048da:	5f                   	pop    %edi
801048db:	5d                   	pop    %ebp
801048dc:	c3                   	ret    
801048dd:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("cld; rep stosb" :
801048e0:	89 d7                	mov    %edx,%edi
801048e2:	fc                   	cld    
801048e3:	f3 aa                	rep stos %al,%es:(%edi)
801048e5:	5b                   	pop    %ebx
801048e6:	89 d0                	mov    %edx,%eax
801048e8:	5f                   	pop    %edi
801048e9:	5d                   	pop    %ebp
801048ea:	c3                   	ret    
801048eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801048ef:	90                   	nop

801048f0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
801048f0:	f3 0f 1e fb          	endbr32 
801048f4:	55                   	push   %ebp
801048f5:	89 e5                	mov    %esp,%ebp
801048f7:	56                   	push   %esi
801048f8:	8b 75 10             	mov    0x10(%ebp),%esi
801048fb:	8b 55 08             	mov    0x8(%ebp),%edx
801048fe:	53                   	push   %ebx
801048ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80104902:	85 f6                	test   %esi,%esi
80104904:	74 2a                	je     80104930 <memcmp+0x40>
80104906:	01 c6                	add    %eax,%esi
80104908:	eb 10                	jmp    8010491a <memcmp+0x2a>
8010490a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
80104910:	83 c0 01             	add    $0x1,%eax
80104913:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
80104916:	39 f0                	cmp    %esi,%eax
80104918:	74 16                	je     80104930 <memcmp+0x40>
    if(*s1 != *s2)
8010491a:	0f b6 0a             	movzbl (%edx),%ecx
8010491d:	0f b6 18             	movzbl (%eax),%ebx
80104920:	38 d9                	cmp    %bl,%cl
80104922:	74 ec                	je     80104910 <memcmp+0x20>
      return *s1 - *s2;
80104924:	0f b6 c1             	movzbl %cl,%eax
80104927:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
80104929:	5b                   	pop    %ebx
8010492a:	5e                   	pop    %esi
8010492b:	5d                   	pop    %ebp
8010492c:	c3                   	ret    
8010492d:	8d 76 00             	lea    0x0(%esi),%esi
80104930:	5b                   	pop    %ebx
  return 0;
80104931:	31 c0                	xor    %eax,%eax
}
80104933:	5e                   	pop    %esi
80104934:	5d                   	pop    %ebp
80104935:	c3                   	ret    
80104936:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010493d:	8d 76 00             	lea    0x0(%esi),%esi

80104940 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104940:	f3 0f 1e fb          	endbr32 
80104944:	55                   	push   %ebp
80104945:	89 e5                	mov    %esp,%ebp
80104947:	57                   	push   %edi
80104948:	8b 55 08             	mov    0x8(%ebp),%edx
8010494b:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010494e:	56                   	push   %esi
8010494f:	8b 75 0c             	mov    0xc(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80104952:	39 d6                	cmp    %edx,%esi
80104954:	73 2a                	jae    80104980 <memmove+0x40>
80104956:	8d 3c 0e             	lea    (%esi,%ecx,1),%edi
80104959:	39 fa                	cmp    %edi,%edx
8010495b:	73 23                	jae    80104980 <memmove+0x40>
8010495d:	8d 41 ff             	lea    -0x1(%ecx),%eax
    s += n;
    d += n;
    while(n-- > 0)
80104960:	85 c9                	test   %ecx,%ecx
80104962:	74 13                	je     80104977 <memmove+0x37>
80104964:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      *--d = *--s;
80104968:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
8010496c:	88 0c 02             	mov    %cl,(%edx,%eax,1)
    while(n-- > 0)
8010496f:	83 e8 01             	sub    $0x1,%eax
80104972:	83 f8 ff             	cmp    $0xffffffff,%eax
80104975:	75 f1                	jne    80104968 <memmove+0x28>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
80104977:	5e                   	pop    %esi
80104978:	89 d0                	mov    %edx,%eax
8010497a:	5f                   	pop    %edi
8010497b:	5d                   	pop    %ebp
8010497c:	c3                   	ret    
8010497d:	8d 76 00             	lea    0x0(%esi),%esi
    while(n-- > 0)
80104980:	8d 04 0e             	lea    (%esi,%ecx,1),%eax
80104983:	89 d7                	mov    %edx,%edi
80104985:	85 c9                	test   %ecx,%ecx
80104987:	74 ee                	je     80104977 <memmove+0x37>
80104989:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      *d++ = *s++;
80104990:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while(n-- > 0)
80104991:	39 f0                	cmp    %esi,%eax
80104993:	75 fb                	jne    80104990 <memmove+0x50>
}
80104995:	5e                   	pop    %esi
80104996:	89 d0                	mov    %edx,%eax
80104998:	5f                   	pop    %edi
80104999:	5d                   	pop    %ebp
8010499a:	c3                   	ret    
8010499b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010499f:	90                   	nop

801049a0 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
801049a0:	f3 0f 1e fb          	endbr32 
  return memmove(dst, src, n);
801049a4:	eb 9a                	jmp    80104940 <memmove>
801049a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801049ad:	8d 76 00             	lea    0x0(%esi),%esi

801049b0 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
801049b0:	f3 0f 1e fb          	endbr32 
801049b4:	55                   	push   %ebp
801049b5:	89 e5                	mov    %esp,%ebp
801049b7:	56                   	push   %esi
801049b8:	8b 75 10             	mov    0x10(%ebp),%esi
801049bb:	8b 4d 08             	mov    0x8(%ebp),%ecx
801049be:	53                   	push   %ebx
801049bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  while(n > 0 && *p && *p == *q)
801049c2:	85 f6                	test   %esi,%esi
801049c4:	74 32                	je     801049f8 <strncmp+0x48>
801049c6:	01 c6                	add    %eax,%esi
801049c8:	eb 14                	jmp    801049de <strncmp+0x2e>
801049ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801049d0:	38 da                	cmp    %bl,%dl
801049d2:	75 14                	jne    801049e8 <strncmp+0x38>
    n--, p++, q++;
801049d4:	83 c0 01             	add    $0x1,%eax
801049d7:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
801049da:	39 f0                	cmp    %esi,%eax
801049dc:	74 1a                	je     801049f8 <strncmp+0x48>
801049de:	0f b6 11             	movzbl (%ecx),%edx
801049e1:	0f b6 18             	movzbl (%eax),%ebx
801049e4:	84 d2                	test   %dl,%dl
801049e6:	75 e8                	jne    801049d0 <strncmp+0x20>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
801049e8:	0f b6 c2             	movzbl %dl,%eax
801049eb:	29 d8                	sub    %ebx,%eax
}
801049ed:	5b                   	pop    %ebx
801049ee:	5e                   	pop    %esi
801049ef:	5d                   	pop    %ebp
801049f0:	c3                   	ret    
801049f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801049f8:	5b                   	pop    %ebx
    return 0;
801049f9:	31 c0                	xor    %eax,%eax
}
801049fb:	5e                   	pop    %esi
801049fc:	5d                   	pop    %ebp
801049fd:	c3                   	ret    
801049fe:	66 90                	xchg   %ax,%ax

80104a00 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104a00:	f3 0f 1e fb          	endbr32 
80104a04:	55                   	push   %ebp
80104a05:	89 e5                	mov    %esp,%ebp
80104a07:	57                   	push   %edi
80104a08:	56                   	push   %esi
80104a09:	8b 75 08             	mov    0x8(%ebp),%esi
80104a0c:	53                   	push   %ebx
80104a0d:	8b 45 10             	mov    0x10(%ebp),%eax
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80104a10:	89 f2                	mov    %esi,%edx
80104a12:	eb 1b                	jmp    80104a2f <strncpy+0x2f>
80104a14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104a18:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
80104a1c:	8b 7d 0c             	mov    0xc(%ebp),%edi
80104a1f:	83 c2 01             	add    $0x1,%edx
80104a22:	0f b6 7f ff          	movzbl -0x1(%edi),%edi
80104a26:	89 f9                	mov    %edi,%ecx
80104a28:	88 4a ff             	mov    %cl,-0x1(%edx)
80104a2b:	84 c9                	test   %cl,%cl
80104a2d:	74 09                	je     80104a38 <strncpy+0x38>
80104a2f:	89 c3                	mov    %eax,%ebx
80104a31:	83 e8 01             	sub    $0x1,%eax
80104a34:	85 db                	test   %ebx,%ebx
80104a36:	7f e0                	jg     80104a18 <strncpy+0x18>
    ;
  while(n-- > 0)
80104a38:	89 d1                	mov    %edx,%ecx
80104a3a:	85 c0                	test   %eax,%eax
80104a3c:	7e 15                	jle    80104a53 <strncpy+0x53>
80104a3e:	66 90                	xchg   %ax,%ax
    *s++ = 0;
80104a40:	83 c1 01             	add    $0x1,%ecx
80104a43:	c6 41 ff 00          	movb   $0x0,-0x1(%ecx)
  while(n-- > 0)
80104a47:	89 c8                	mov    %ecx,%eax
80104a49:	f7 d0                	not    %eax
80104a4b:	01 d0                	add    %edx,%eax
80104a4d:	01 d8                	add    %ebx,%eax
80104a4f:	85 c0                	test   %eax,%eax
80104a51:	7f ed                	jg     80104a40 <strncpy+0x40>
  return os;
}
80104a53:	5b                   	pop    %ebx
80104a54:	89 f0                	mov    %esi,%eax
80104a56:	5e                   	pop    %esi
80104a57:	5f                   	pop    %edi
80104a58:	5d                   	pop    %ebp
80104a59:	c3                   	ret    
80104a5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104a60 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104a60:	f3 0f 1e fb          	endbr32 
80104a64:	55                   	push   %ebp
80104a65:	89 e5                	mov    %esp,%ebp
80104a67:	56                   	push   %esi
80104a68:	8b 55 10             	mov    0x10(%ebp),%edx
80104a6b:	8b 75 08             	mov    0x8(%ebp),%esi
80104a6e:	53                   	push   %ebx
80104a6f:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *os;

  os = s;
  if(n <= 0)
80104a72:	85 d2                	test   %edx,%edx
80104a74:	7e 21                	jle    80104a97 <safestrcpy+0x37>
80104a76:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
80104a7a:	89 f2                	mov    %esi,%edx
80104a7c:	eb 12                	jmp    80104a90 <safestrcpy+0x30>
80104a7e:	66 90                	xchg   %ax,%ax
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104a80:	0f b6 08             	movzbl (%eax),%ecx
80104a83:	83 c0 01             	add    $0x1,%eax
80104a86:	83 c2 01             	add    $0x1,%edx
80104a89:	88 4a ff             	mov    %cl,-0x1(%edx)
80104a8c:	84 c9                	test   %cl,%cl
80104a8e:	74 04                	je     80104a94 <safestrcpy+0x34>
80104a90:	39 d8                	cmp    %ebx,%eax
80104a92:	75 ec                	jne    80104a80 <safestrcpy+0x20>
    ;
  *s = 0;
80104a94:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
80104a97:	89 f0                	mov    %esi,%eax
80104a99:	5b                   	pop    %ebx
80104a9a:	5e                   	pop    %esi
80104a9b:	5d                   	pop    %ebp
80104a9c:	c3                   	ret    
80104a9d:	8d 76 00             	lea    0x0(%esi),%esi

80104aa0 <strlen>:

int
strlen(const char *s)
{
80104aa0:	f3 0f 1e fb          	endbr32 
80104aa4:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104aa5:	31 c0                	xor    %eax,%eax
{
80104aa7:	89 e5                	mov    %esp,%ebp
80104aa9:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80104aac:	80 3a 00             	cmpb   $0x0,(%edx)
80104aaf:	74 10                	je     80104ac1 <strlen+0x21>
80104ab1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ab8:	83 c0 01             	add    $0x1,%eax
80104abb:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104abf:	75 f7                	jne    80104ab8 <strlen+0x18>
    ;
  return n;
}
80104ac1:	5d                   	pop    %ebp
80104ac2:	c3                   	ret    

80104ac3 <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80104ac3:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80104ac7:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80104acb:	55                   	push   %ebp
  pushl %ebx
80104acc:	53                   	push   %ebx
  pushl %esi
80104acd:	56                   	push   %esi
  pushl %edi
80104ace:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104acf:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104ad1:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
80104ad3:	5f                   	pop    %edi
  popl %esi
80104ad4:	5e                   	pop    %esi
  popl %ebx
80104ad5:	5b                   	pop    %ebx
  popl %ebp
80104ad6:	5d                   	pop    %ebp
  ret
80104ad7:	c3                   	ret    
80104ad8:	66 90                	xchg   %ax,%ax
80104ada:	66 90                	xchg   %ax,%ax
80104adc:	66 90                	xchg   %ax,%ax
80104ade:	66 90                	xchg   %ax,%ax

80104ae0 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104ae0:	f3 0f 1e fb          	endbr32 
80104ae4:	55                   	push   %ebp
80104ae5:	89 e5                	mov    %esp,%ebp
80104ae7:	53                   	push   %ebx
80104ae8:	83 ec 04             	sub    $0x4,%esp
80104aeb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
80104aee:	e8 9d f0 ff ff       	call   80103b90 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104af3:	8b 00                	mov    (%eax),%eax
80104af5:	39 d8                	cmp    %ebx,%eax
80104af7:	76 17                	jbe    80104b10 <fetchint+0x30>
80104af9:	8d 53 04             	lea    0x4(%ebx),%edx
80104afc:	39 d0                	cmp    %edx,%eax
80104afe:	72 10                	jb     80104b10 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
80104b00:	8b 45 0c             	mov    0xc(%ebp),%eax
80104b03:	8b 13                	mov    (%ebx),%edx
80104b05:	89 10                	mov    %edx,(%eax)
  return 0;
80104b07:	31 c0                	xor    %eax,%eax
}
80104b09:	83 c4 04             	add    $0x4,%esp
80104b0c:	5b                   	pop    %ebx
80104b0d:	5d                   	pop    %ebp
80104b0e:	c3                   	ret    
80104b0f:	90                   	nop
    return -1;
80104b10:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104b15:	eb f2                	jmp    80104b09 <fetchint+0x29>
80104b17:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b1e:	66 90                	xchg   %ax,%ax

80104b20 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104b20:	f3 0f 1e fb          	endbr32 
80104b24:	55                   	push   %ebp
80104b25:	89 e5                	mov    %esp,%ebp
80104b27:	53                   	push   %ebx
80104b28:	83 ec 04             	sub    $0x4,%esp
80104b2b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
80104b2e:	e8 5d f0 ff ff       	call   80103b90 <myproc>

  if(addr >= curproc->sz)
80104b33:	39 18                	cmp    %ebx,(%eax)
80104b35:	76 31                	jbe    80104b68 <fetchstr+0x48>
    return -1;
  *pp = (char*)addr;
80104b37:	8b 55 0c             	mov    0xc(%ebp),%edx
80104b3a:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80104b3c:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
80104b3e:	39 d3                	cmp    %edx,%ebx
80104b40:	73 26                	jae    80104b68 <fetchstr+0x48>
80104b42:	89 d8                	mov    %ebx,%eax
80104b44:	eb 11                	jmp    80104b57 <fetchstr+0x37>
80104b46:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b4d:	8d 76 00             	lea    0x0(%esi),%esi
80104b50:	83 c0 01             	add    $0x1,%eax
80104b53:	39 c2                	cmp    %eax,%edx
80104b55:	76 11                	jbe    80104b68 <fetchstr+0x48>
    if(*s == 0)
80104b57:	80 38 00             	cmpb   $0x0,(%eax)
80104b5a:	75 f4                	jne    80104b50 <fetchstr+0x30>
      return s - *pp;
  }
  return -1;
}
80104b5c:	83 c4 04             	add    $0x4,%esp
      return s - *pp;
80104b5f:	29 d8                	sub    %ebx,%eax
}
80104b61:	5b                   	pop    %ebx
80104b62:	5d                   	pop    %ebp
80104b63:	c3                   	ret    
80104b64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104b68:	83 c4 04             	add    $0x4,%esp
    return -1;
80104b6b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104b70:	5b                   	pop    %ebx
80104b71:	5d                   	pop    %ebp
80104b72:	c3                   	ret    
80104b73:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104b80 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104b80:	f3 0f 1e fb          	endbr32 
80104b84:	55                   	push   %ebp
80104b85:	89 e5                	mov    %esp,%ebp
80104b87:	56                   	push   %esi
80104b88:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104b89:	e8 02 f0 ff ff       	call   80103b90 <myproc>
80104b8e:	8b 55 08             	mov    0x8(%ebp),%edx
80104b91:	8b 40 18             	mov    0x18(%eax),%eax
80104b94:	8b 40 44             	mov    0x44(%eax),%eax
80104b97:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104b9a:	e8 f1 ef ff ff       	call   80103b90 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104b9f:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104ba2:	8b 00                	mov    (%eax),%eax
80104ba4:	39 c6                	cmp    %eax,%esi
80104ba6:	73 18                	jae    80104bc0 <argint+0x40>
80104ba8:	8d 53 08             	lea    0x8(%ebx),%edx
80104bab:	39 d0                	cmp    %edx,%eax
80104bad:	72 11                	jb     80104bc0 <argint+0x40>
  *ip = *(int*)(addr);
80104baf:	8b 45 0c             	mov    0xc(%ebp),%eax
80104bb2:	8b 53 04             	mov    0x4(%ebx),%edx
80104bb5:	89 10                	mov    %edx,(%eax)
  return 0;
80104bb7:	31 c0                	xor    %eax,%eax
}
80104bb9:	5b                   	pop    %ebx
80104bba:	5e                   	pop    %esi
80104bbb:	5d                   	pop    %ebp
80104bbc:	c3                   	ret    
80104bbd:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80104bc0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104bc5:	eb f2                	jmp    80104bb9 <argint+0x39>
80104bc7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104bce:	66 90                	xchg   %ax,%ax

80104bd0 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104bd0:	f3 0f 1e fb          	endbr32 
80104bd4:	55                   	push   %ebp
80104bd5:	89 e5                	mov    %esp,%ebp
80104bd7:	56                   	push   %esi
80104bd8:	53                   	push   %ebx
80104bd9:	83 ec 10             	sub    $0x10,%esp
80104bdc:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
80104bdf:	e8 ac ef ff ff       	call   80103b90 <myproc>
 
  if(argint(n, &i) < 0)
80104be4:	83 ec 08             	sub    $0x8,%esp
  struct proc *curproc = myproc();
80104be7:	89 c6                	mov    %eax,%esi
  if(argint(n, &i) < 0)
80104be9:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104bec:	50                   	push   %eax
80104bed:	ff 75 08             	pushl  0x8(%ebp)
80104bf0:	e8 8b ff ff ff       	call   80104b80 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104bf5:	83 c4 10             	add    $0x10,%esp
80104bf8:	85 c0                	test   %eax,%eax
80104bfa:	78 24                	js     80104c20 <argptr+0x50>
80104bfc:	85 db                	test   %ebx,%ebx
80104bfe:	78 20                	js     80104c20 <argptr+0x50>
80104c00:	8b 16                	mov    (%esi),%edx
80104c02:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c05:	39 c2                	cmp    %eax,%edx
80104c07:	76 17                	jbe    80104c20 <argptr+0x50>
80104c09:	01 c3                	add    %eax,%ebx
80104c0b:	39 da                	cmp    %ebx,%edx
80104c0d:	72 11                	jb     80104c20 <argptr+0x50>
    return -1;
  *pp = (char*)i;
80104c0f:	8b 55 0c             	mov    0xc(%ebp),%edx
80104c12:	89 02                	mov    %eax,(%edx)
  return 0;
80104c14:	31 c0                	xor    %eax,%eax
}
80104c16:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104c19:	5b                   	pop    %ebx
80104c1a:	5e                   	pop    %esi
80104c1b:	5d                   	pop    %ebp
80104c1c:	c3                   	ret    
80104c1d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80104c20:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104c25:	eb ef                	jmp    80104c16 <argptr+0x46>
80104c27:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c2e:	66 90                	xchg   %ax,%ax

80104c30 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104c30:	f3 0f 1e fb          	endbr32 
80104c34:	55                   	push   %ebp
80104c35:	89 e5                	mov    %esp,%ebp
80104c37:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
80104c3a:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104c3d:	50                   	push   %eax
80104c3e:	ff 75 08             	pushl  0x8(%ebp)
80104c41:	e8 3a ff ff ff       	call   80104b80 <argint>
80104c46:	83 c4 10             	add    $0x10,%esp
80104c49:	85 c0                	test   %eax,%eax
80104c4b:	78 13                	js     80104c60 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
80104c4d:	83 ec 08             	sub    $0x8,%esp
80104c50:	ff 75 0c             	pushl  0xc(%ebp)
80104c53:	ff 75 f4             	pushl  -0xc(%ebp)
80104c56:	e8 c5 fe ff ff       	call   80104b20 <fetchstr>
80104c5b:	83 c4 10             	add    $0x10,%esp
}
80104c5e:	c9                   	leave  
80104c5f:	c3                   	ret    
80104c60:	c9                   	leave  
    return -1;
80104c61:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104c66:	c3                   	ret    
80104c67:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c6e:	66 90                	xchg   %ax,%ax

80104c70 <syscall>:
[SYS_getnextprime] sys_getnextprime,
};

void
syscall(void)
{
80104c70:	f3 0f 1e fb          	endbr32 
80104c74:	55                   	push   %ebp
80104c75:	89 e5                	mov    %esp,%ebp
80104c77:	53                   	push   %ebx
80104c78:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80104c7b:	e8 10 ef ff ff       	call   80103b90 <myproc>
  curproc->counter = curproc->counter+1;
80104c80:	83 40 7c 01          	addl   $0x1,0x7c(%eax)
  struct proc *curproc = myproc();
80104c84:	89 c3                	mov    %eax,%ebx
  num = curproc->tf->eax;
80104c86:	8b 40 18             	mov    0x18(%eax),%eax
80104c89:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104c8c:	8d 50 ff             	lea    -0x1(%eax),%edx
80104c8f:	83 fa 16             	cmp    $0x16,%edx
80104c92:	77 1c                	ja     80104cb0 <syscall+0x40>
80104c94:	8b 14 85 40 7a 10 80 	mov    -0x7fef85c0(,%eax,4),%edx
80104c9b:	85 d2                	test   %edx,%edx
80104c9d:	74 11                	je     80104cb0 <syscall+0x40>
    curproc->tf->eax = syscalls[num]();
80104c9f:	ff d2                	call   *%edx
80104ca1:	89 c2                	mov    %eax,%edx
80104ca3:	8b 43 18             	mov    0x18(%ebx),%eax
80104ca6:	89 50 1c             	mov    %edx,0x1c(%eax)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80104ca9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104cac:	c9                   	leave  
80104cad:	c3                   	ret    
80104cae:	66 90                	xchg   %ax,%ax
    cprintf("%d %s: unknown sys call %d\n",
80104cb0:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80104cb1:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80104cb4:	50                   	push   %eax
80104cb5:	ff 73 10             	pushl  0x10(%ebx)
80104cb8:	68 1d 7a 10 80       	push   $0x80107a1d
80104cbd:	e8 5e ba ff ff       	call   80100720 <cprintf>
    curproc->tf->eax = -1;
80104cc2:	8b 43 18             	mov    0x18(%ebx),%eax
80104cc5:	83 c4 10             	add    $0x10,%esp
80104cc8:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80104ccf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104cd2:	c9                   	leave  
80104cd3:	c3                   	ret    
80104cd4:	66 90                	xchg   %ax,%ax
80104cd6:	66 90                	xchg   %ax,%ax
80104cd8:	66 90                	xchg   %ax,%ax
80104cda:	66 90                	xchg   %ax,%ax
80104cdc:	66 90                	xchg   %ax,%ax
80104cde:	66 90                	xchg   %ax,%ax

80104ce0 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104ce0:	55                   	push   %ebp
80104ce1:	89 e5                	mov    %esp,%ebp
80104ce3:	57                   	push   %edi
80104ce4:	56                   	push   %esi
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104ce5:	8d 7d da             	lea    -0x26(%ebp),%edi
{
80104ce8:	53                   	push   %ebx
80104ce9:	83 ec 34             	sub    $0x34,%esp
80104cec:	89 4d d0             	mov    %ecx,-0x30(%ebp)
80104cef:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80104cf2:	57                   	push   %edi
80104cf3:	50                   	push   %eax
{
80104cf4:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80104cf7:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
80104cfa:	e8 71 d5 ff ff       	call   80102270 <nameiparent>
80104cff:	83 c4 10             	add    $0x10,%esp
80104d02:	85 c0                	test   %eax,%eax
80104d04:	0f 84 46 01 00 00    	je     80104e50 <create+0x170>
    return 0;
  ilock(dp);
80104d0a:	83 ec 0c             	sub    $0xc,%esp
80104d0d:	89 c3                	mov    %eax,%ebx
80104d0f:	50                   	push   %eax
80104d10:	e8 6b cc ff ff       	call   80101980 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
80104d15:	83 c4 0c             	add    $0xc,%esp
80104d18:	6a 00                	push   $0x0
80104d1a:	57                   	push   %edi
80104d1b:	53                   	push   %ebx
80104d1c:	e8 af d1 ff ff       	call   80101ed0 <dirlookup>
80104d21:	83 c4 10             	add    $0x10,%esp
80104d24:	89 c6                	mov    %eax,%esi
80104d26:	85 c0                	test   %eax,%eax
80104d28:	74 56                	je     80104d80 <create+0xa0>
    iunlockput(dp);
80104d2a:	83 ec 0c             	sub    $0xc,%esp
80104d2d:	53                   	push   %ebx
80104d2e:	e8 ed ce ff ff       	call   80101c20 <iunlockput>
    ilock(ip);
80104d33:	89 34 24             	mov    %esi,(%esp)
80104d36:	e8 45 cc ff ff       	call   80101980 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80104d3b:	83 c4 10             	add    $0x10,%esp
80104d3e:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80104d43:	75 1b                	jne    80104d60 <create+0x80>
80104d45:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
80104d4a:	75 14                	jne    80104d60 <create+0x80>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104d4c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104d4f:	89 f0                	mov    %esi,%eax
80104d51:	5b                   	pop    %ebx
80104d52:	5e                   	pop    %esi
80104d53:	5f                   	pop    %edi
80104d54:	5d                   	pop    %ebp
80104d55:	c3                   	ret    
80104d56:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d5d:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
80104d60:	83 ec 0c             	sub    $0xc,%esp
80104d63:	56                   	push   %esi
    return 0;
80104d64:	31 f6                	xor    %esi,%esi
    iunlockput(ip);
80104d66:	e8 b5 ce ff ff       	call   80101c20 <iunlockput>
    return 0;
80104d6b:	83 c4 10             	add    $0x10,%esp
}
80104d6e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104d71:	89 f0                	mov    %esi,%eax
80104d73:	5b                   	pop    %ebx
80104d74:	5e                   	pop    %esi
80104d75:	5f                   	pop    %edi
80104d76:	5d                   	pop    %ebp
80104d77:	c3                   	ret    
80104d78:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d7f:	90                   	nop
  if((ip = ialloc(dp->dev, type)) == 0)
80104d80:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80104d84:	83 ec 08             	sub    $0x8,%esp
80104d87:	50                   	push   %eax
80104d88:	ff 33                	pushl  (%ebx)
80104d8a:	e8 71 ca ff ff       	call   80101800 <ialloc>
80104d8f:	83 c4 10             	add    $0x10,%esp
80104d92:	89 c6                	mov    %eax,%esi
80104d94:	85 c0                	test   %eax,%eax
80104d96:	0f 84 cd 00 00 00    	je     80104e69 <create+0x189>
  ilock(ip);
80104d9c:	83 ec 0c             	sub    $0xc,%esp
80104d9f:	50                   	push   %eax
80104da0:	e8 db cb ff ff       	call   80101980 <ilock>
  ip->major = major;
80104da5:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80104da9:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
80104dad:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80104db1:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
80104db5:	b8 01 00 00 00       	mov    $0x1,%eax
80104dba:	66 89 46 56          	mov    %ax,0x56(%esi)
  iupdate(ip);
80104dbe:	89 34 24             	mov    %esi,(%esp)
80104dc1:	e8 fa ca ff ff       	call   801018c0 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80104dc6:	83 c4 10             	add    $0x10,%esp
80104dc9:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80104dce:	74 30                	je     80104e00 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
80104dd0:	83 ec 04             	sub    $0x4,%esp
80104dd3:	ff 76 04             	pushl  0x4(%esi)
80104dd6:	57                   	push   %edi
80104dd7:	53                   	push   %ebx
80104dd8:	e8 b3 d3 ff ff       	call   80102190 <dirlink>
80104ddd:	83 c4 10             	add    $0x10,%esp
80104de0:	85 c0                	test   %eax,%eax
80104de2:	78 78                	js     80104e5c <create+0x17c>
  iunlockput(dp);
80104de4:	83 ec 0c             	sub    $0xc,%esp
80104de7:	53                   	push   %ebx
80104de8:	e8 33 ce ff ff       	call   80101c20 <iunlockput>
  return ip;
80104ded:	83 c4 10             	add    $0x10,%esp
}
80104df0:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104df3:	89 f0                	mov    %esi,%eax
80104df5:	5b                   	pop    %ebx
80104df6:	5e                   	pop    %esi
80104df7:	5f                   	pop    %edi
80104df8:	5d                   	pop    %ebp
80104df9:	c3                   	ret    
80104dfa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iupdate(dp);
80104e00:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink++;  // for ".."
80104e03:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80104e08:	53                   	push   %ebx
80104e09:	e8 b2 ca ff ff       	call   801018c0 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80104e0e:	83 c4 0c             	add    $0xc,%esp
80104e11:	ff 76 04             	pushl  0x4(%esi)
80104e14:	68 bc 7a 10 80       	push   $0x80107abc
80104e19:	56                   	push   %esi
80104e1a:	e8 71 d3 ff ff       	call   80102190 <dirlink>
80104e1f:	83 c4 10             	add    $0x10,%esp
80104e22:	85 c0                	test   %eax,%eax
80104e24:	78 18                	js     80104e3e <create+0x15e>
80104e26:	83 ec 04             	sub    $0x4,%esp
80104e29:	ff 73 04             	pushl  0x4(%ebx)
80104e2c:	68 bb 7a 10 80       	push   $0x80107abb
80104e31:	56                   	push   %esi
80104e32:	e8 59 d3 ff ff       	call   80102190 <dirlink>
80104e37:	83 c4 10             	add    $0x10,%esp
80104e3a:	85 c0                	test   %eax,%eax
80104e3c:	79 92                	jns    80104dd0 <create+0xf0>
      panic("create dots");
80104e3e:	83 ec 0c             	sub    $0xc,%esp
80104e41:	68 af 7a 10 80       	push   $0x80107aaf
80104e46:	e8 45 b5 ff ff       	call   80100390 <panic>
80104e4b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104e4f:	90                   	nop
}
80104e50:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80104e53:	31 f6                	xor    %esi,%esi
}
80104e55:	5b                   	pop    %ebx
80104e56:	89 f0                	mov    %esi,%eax
80104e58:	5e                   	pop    %esi
80104e59:	5f                   	pop    %edi
80104e5a:	5d                   	pop    %ebp
80104e5b:	c3                   	ret    
    panic("create: dirlink");
80104e5c:	83 ec 0c             	sub    $0xc,%esp
80104e5f:	68 be 7a 10 80       	push   $0x80107abe
80104e64:	e8 27 b5 ff ff       	call   80100390 <panic>
    panic("create: ialloc");
80104e69:	83 ec 0c             	sub    $0xc,%esp
80104e6c:	68 a0 7a 10 80       	push   $0x80107aa0
80104e71:	e8 1a b5 ff ff       	call   80100390 <panic>
80104e76:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e7d:	8d 76 00             	lea    0x0(%esi),%esi

80104e80 <argfd.constprop.0>:
argfd(int n, int *pfd, struct file **pf)
80104e80:	55                   	push   %ebp
80104e81:	89 e5                	mov    %esp,%ebp
80104e83:	56                   	push   %esi
80104e84:	89 d6                	mov    %edx,%esi
80104e86:	53                   	push   %ebx
80104e87:	89 c3                	mov    %eax,%ebx
  if(argint(n, &fd) < 0)
80104e89:	8d 45 f4             	lea    -0xc(%ebp),%eax
argfd(int n, int *pfd, struct file **pf)
80104e8c:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104e8f:	50                   	push   %eax
80104e90:	6a 00                	push   $0x0
80104e92:	e8 e9 fc ff ff       	call   80104b80 <argint>
80104e97:	83 c4 10             	add    $0x10,%esp
80104e9a:	85 c0                	test   %eax,%eax
80104e9c:	78 2a                	js     80104ec8 <argfd.constprop.0+0x48>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104e9e:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104ea2:	77 24                	ja     80104ec8 <argfd.constprop.0+0x48>
80104ea4:	e8 e7 ec ff ff       	call   80103b90 <myproc>
80104ea9:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104eac:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
80104eb0:	85 c0                	test   %eax,%eax
80104eb2:	74 14                	je     80104ec8 <argfd.constprop.0+0x48>
  if(pfd)
80104eb4:	85 db                	test   %ebx,%ebx
80104eb6:	74 02                	je     80104eba <argfd.constprop.0+0x3a>
    *pfd = fd;
80104eb8:	89 13                	mov    %edx,(%ebx)
    *pf = f;
80104eba:	89 06                	mov    %eax,(%esi)
  return 0;
80104ebc:	31 c0                	xor    %eax,%eax
}
80104ebe:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104ec1:	5b                   	pop    %ebx
80104ec2:	5e                   	pop    %esi
80104ec3:	5d                   	pop    %ebp
80104ec4:	c3                   	ret    
80104ec5:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80104ec8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104ecd:	eb ef                	jmp    80104ebe <argfd.constprop.0+0x3e>
80104ecf:	90                   	nop

80104ed0 <sys_dup>:
{
80104ed0:	f3 0f 1e fb          	endbr32 
80104ed4:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0)
80104ed5:	31 c0                	xor    %eax,%eax
{
80104ed7:	89 e5                	mov    %esp,%ebp
80104ed9:	56                   	push   %esi
80104eda:	53                   	push   %ebx
  if(argfd(0, 0, &f) < 0)
80104edb:	8d 55 f4             	lea    -0xc(%ebp),%edx
{
80104ede:	83 ec 10             	sub    $0x10,%esp
  if(argfd(0, 0, &f) < 0)
80104ee1:	e8 9a ff ff ff       	call   80104e80 <argfd.constprop.0>
80104ee6:	85 c0                	test   %eax,%eax
80104ee8:	78 1e                	js     80104f08 <sys_dup+0x38>
  if((fd=fdalloc(f)) < 0)
80104eea:	8b 75 f4             	mov    -0xc(%ebp),%esi
  for(fd = 0; fd < NOFILE; fd++){
80104eed:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80104eef:	e8 9c ec ff ff       	call   80103b90 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80104ef4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80104ef8:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80104efc:	85 d2                	test   %edx,%edx
80104efe:	74 20                	je     80104f20 <sys_dup+0x50>
  for(fd = 0; fd < NOFILE; fd++){
80104f00:	83 c3 01             	add    $0x1,%ebx
80104f03:	83 fb 10             	cmp    $0x10,%ebx
80104f06:	75 f0                	jne    80104ef8 <sys_dup+0x28>
}
80104f08:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
80104f0b:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80104f10:	89 d8                	mov    %ebx,%eax
80104f12:	5b                   	pop    %ebx
80104f13:	5e                   	pop    %esi
80104f14:	5d                   	pop    %ebp
80104f15:	c3                   	ret    
80104f16:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f1d:	8d 76 00             	lea    0x0(%esi),%esi
      curproc->ofile[fd] = f;
80104f20:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
80104f24:	83 ec 0c             	sub    $0xc,%esp
80104f27:	ff 75 f4             	pushl  -0xc(%ebp)
80104f2a:	e8 61 c1 ff ff       	call   80101090 <filedup>
  return fd;
80104f2f:	83 c4 10             	add    $0x10,%esp
}
80104f32:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104f35:	89 d8                	mov    %ebx,%eax
80104f37:	5b                   	pop    %ebx
80104f38:	5e                   	pop    %esi
80104f39:	5d                   	pop    %ebp
80104f3a:	c3                   	ret    
80104f3b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104f3f:	90                   	nop

80104f40 <sys_read>:
{
80104f40:	f3 0f 1e fb          	endbr32 
80104f44:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104f45:	31 c0                	xor    %eax,%eax
{
80104f47:	89 e5                	mov    %esp,%ebp
80104f49:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104f4c:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104f4f:	e8 2c ff ff ff       	call   80104e80 <argfd.constprop.0>
80104f54:	85 c0                	test   %eax,%eax
80104f56:	78 48                	js     80104fa0 <sys_read+0x60>
80104f58:	83 ec 08             	sub    $0x8,%esp
80104f5b:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104f5e:	50                   	push   %eax
80104f5f:	6a 02                	push   $0x2
80104f61:	e8 1a fc ff ff       	call   80104b80 <argint>
80104f66:	83 c4 10             	add    $0x10,%esp
80104f69:	85 c0                	test   %eax,%eax
80104f6b:	78 33                	js     80104fa0 <sys_read+0x60>
80104f6d:	83 ec 04             	sub    $0x4,%esp
80104f70:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104f73:	ff 75 f0             	pushl  -0x10(%ebp)
80104f76:	50                   	push   %eax
80104f77:	6a 01                	push   $0x1
80104f79:	e8 52 fc ff ff       	call   80104bd0 <argptr>
80104f7e:	83 c4 10             	add    $0x10,%esp
80104f81:	85 c0                	test   %eax,%eax
80104f83:	78 1b                	js     80104fa0 <sys_read+0x60>
  return fileread(f, p, n);
80104f85:	83 ec 04             	sub    $0x4,%esp
80104f88:	ff 75 f0             	pushl  -0x10(%ebp)
80104f8b:	ff 75 f4             	pushl  -0xc(%ebp)
80104f8e:	ff 75 ec             	pushl  -0x14(%ebp)
80104f91:	e8 7a c2 ff ff       	call   80101210 <fileread>
80104f96:	83 c4 10             	add    $0x10,%esp
}
80104f99:	c9                   	leave  
80104f9a:	c3                   	ret    
80104f9b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104f9f:	90                   	nop
80104fa0:	c9                   	leave  
    return -1;
80104fa1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104fa6:	c3                   	ret    
80104fa7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104fae:	66 90                	xchg   %ax,%ax

80104fb0 <sys_write>:
{
80104fb0:	f3 0f 1e fb          	endbr32 
80104fb4:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104fb5:	31 c0                	xor    %eax,%eax
{
80104fb7:	89 e5                	mov    %esp,%ebp
80104fb9:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104fbc:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104fbf:	e8 bc fe ff ff       	call   80104e80 <argfd.constprop.0>
80104fc4:	85 c0                	test   %eax,%eax
80104fc6:	78 48                	js     80105010 <sys_write+0x60>
80104fc8:	83 ec 08             	sub    $0x8,%esp
80104fcb:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104fce:	50                   	push   %eax
80104fcf:	6a 02                	push   $0x2
80104fd1:	e8 aa fb ff ff       	call   80104b80 <argint>
80104fd6:	83 c4 10             	add    $0x10,%esp
80104fd9:	85 c0                	test   %eax,%eax
80104fdb:	78 33                	js     80105010 <sys_write+0x60>
80104fdd:	83 ec 04             	sub    $0x4,%esp
80104fe0:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104fe3:	ff 75 f0             	pushl  -0x10(%ebp)
80104fe6:	50                   	push   %eax
80104fe7:	6a 01                	push   $0x1
80104fe9:	e8 e2 fb ff ff       	call   80104bd0 <argptr>
80104fee:	83 c4 10             	add    $0x10,%esp
80104ff1:	85 c0                	test   %eax,%eax
80104ff3:	78 1b                	js     80105010 <sys_write+0x60>
  return filewrite(f, p, n);
80104ff5:	83 ec 04             	sub    $0x4,%esp
80104ff8:	ff 75 f0             	pushl  -0x10(%ebp)
80104ffb:	ff 75 f4             	pushl  -0xc(%ebp)
80104ffe:	ff 75 ec             	pushl  -0x14(%ebp)
80105001:	e8 aa c2 ff ff       	call   801012b0 <filewrite>
80105006:	83 c4 10             	add    $0x10,%esp
}
80105009:	c9                   	leave  
8010500a:	c3                   	ret    
8010500b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010500f:	90                   	nop
80105010:	c9                   	leave  
    return -1;
80105011:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105016:	c3                   	ret    
80105017:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010501e:	66 90                	xchg   %ax,%ax

80105020 <sys_close>:
{
80105020:	f3 0f 1e fb          	endbr32 
80105024:	55                   	push   %ebp
80105025:	89 e5                	mov    %esp,%ebp
80105027:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, &fd, &f) < 0)
8010502a:	8d 55 f4             	lea    -0xc(%ebp),%edx
8010502d:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105030:	e8 4b fe ff ff       	call   80104e80 <argfd.constprop.0>
80105035:	85 c0                	test   %eax,%eax
80105037:	78 27                	js     80105060 <sys_close+0x40>
  myproc()->ofile[fd] = 0;
80105039:	e8 52 eb ff ff       	call   80103b90 <myproc>
8010503e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
80105041:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
80105044:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
8010504b:	00 
  fileclose(f);
8010504c:	ff 75 f4             	pushl  -0xc(%ebp)
8010504f:	e8 8c c0 ff ff       	call   801010e0 <fileclose>
  return 0;
80105054:	83 c4 10             	add    $0x10,%esp
80105057:	31 c0                	xor    %eax,%eax
}
80105059:	c9                   	leave  
8010505a:	c3                   	ret    
8010505b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010505f:	90                   	nop
80105060:	c9                   	leave  
    return -1;
80105061:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105066:	c3                   	ret    
80105067:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010506e:	66 90                	xchg   %ax,%ax

80105070 <sys_fstat>:
{
80105070:	f3 0f 1e fb          	endbr32 
80105074:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105075:	31 c0                	xor    %eax,%eax
{
80105077:	89 e5                	mov    %esp,%ebp
80105079:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
8010507c:	8d 55 f0             	lea    -0x10(%ebp),%edx
8010507f:	e8 fc fd ff ff       	call   80104e80 <argfd.constprop.0>
80105084:	85 c0                	test   %eax,%eax
80105086:	78 30                	js     801050b8 <sys_fstat+0x48>
80105088:	83 ec 04             	sub    $0x4,%esp
8010508b:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010508e:	6a 14                	push   $0x14
80105090:	50                   	push   %eax
80105091:	6a 01                	push   $0x1
80105093:	e8 38 fb ff ff       	call   80104bd0 <argptr>
80105098:	83 c4 10             	add    $0x10,%esp
8010509b:	85 c0                	test   %eax,%eax
8010509d:	78 19                	js     801050b8 <sys_fstat+0x48>
  return filestat(f, st);
8010509f:	83 ec 08             	sub    $0x8,%esp
801050a2:	ff 75 f4             	pushl  -0xc(%ebp)
801050a5:	ff 75 f0             	pushl  -0x10(%ebp)
801050a8:	e8 13 c1 ff ff       	call   801011c0 <filestat>
801050ad:	83 c4 10             	add    $0x10,%esp
}
801050b0:	c9                   	leave  
801050b1:	c3                   	ret    
801050b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801050b8:	c9                   	leave  
    return -1;
801050b9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801050be:	c3                   	ret    
801050bf:	90                   	nop

801050c0 <sys_link>:
{
801050c0:	f3 0f 1e fb          	endbr32 
801050c4:	55                   	push   %ebp
801050c5:	89 e5                	mov    %esp,%ebp
801050c7:	57                   	push   %edi
801050c8:	56                   	push   %esi
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801050c9:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
801050cc:	53                   	push   %ebx
801050cd:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801050d0:	50                   	push   %eax
801050d1:	6a 00                	push   $0x0
801050d3:	e8 58 fb ff ff       	call   80104c30 <argstr>
801050d8:	83 c4 10             	add    $0x10,%esp
801050db:	85 c0                	test   %eax,%eax
801050dd:	0f 88 ff 00 00 00    	js     801051e2 <sys_link+0x122>
801050e3:	83 ec 08             	sub    $0x8,%esp
801050e6:	8d 45 d0             	lea    -0x30(%ebp),%eax
801050e9:	50                   	push   %eax
801050ea:	6a 01                	push   $0x1
801050ec:	e8 3f fb ff ff       	call   80104c30 <argstr>
801050f1:	83 c4 10             	add    $0x10,%esp
801050f4:	85 c0                	test   %eax,%eax
801050f6:	0f 88 e6 00 00 00    	js     801051e2 <sys_link+0x122>
  begin_op();
801050fc:	e8 4f de ff ff       	call   80102f50 <begin_op>
  if((ip = namei(old)) == 0){
80105101:	83 ec 0c             	sub    $0xc,%esp
80105104:	ff 75 d4             	pushl  -0x2c(%ebp)
80105107:	e8 44 d1 ff ff       	call   80102250 <namei>
8010510c:	83 c4 10             	add    $0x10,%esp
8010510f:	89 c3                	mov    %eax,%ebx
80105111:	85 c0                	test   %eax,%eax
80105113:	0f 84 e8 00 00 00    	je     80105201 <sys_link+0x141>
  ilock(ip);
80105119:	83 ec 0c             	sub    $0xc,%esp
8010511c:	50                   	push   %eax
8010511d:	e8 5e c8 ff ff       	call   80101980 <ilock>
  if(ip->type == T_DIR){
80105122:	83 c4 10             	add    $0x10,%esp
80105125:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010512a:	0f 84 b9 00 00 00    	je     801051e9 <sys_link+0x129>
  iupdate(ip);
80105130:	83 ec 0c             	sub    $0xc,%esp
  ip->nlink++;
80105133:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  if((dp = nameiparent(new, name)) == 0)
80105138:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
8010513b:	53                   	push   %ebx
8010513c:	e8 7f c7 ff ff       	call   801018c0 <iupdate>
  iunlock(ip);
80105141:	89 1c 24             	mov    %ebx,(%esp)
80105144:	e8 17 c9 ff ff       	call   80101a60 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80105149:	58                   	pop    %eax
8010514a:	5a                   	pop    %edx
8010514b:	57                   	push   %edi
8010514c:	ff 75 d0             	pushl  -0x30(%ebp)
8010514f:	e8 1c d1 ff ff       	call   80102270 <nameiparent>
80105154:	83 c4 10             	add    $0x10,%esp
80105157:	89 c6                	mov    %eax,%esi
80105159:	85 c0                	test   %eax,%eax
8010515b:	74 5f                	je     801051bc <sys_link+0xfc>
  ilock(dp);
8010515d:	83 ec 0c             	sub    $0xc,%esp
80105160:	50                   	push   %eax
80105161:	e8 1a c8 ff ff       	call   80101980 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105166:	8b 03                	mov    (%ebx),%eax
80105168:	83 c4 10             	add    $0x10,%esp
8010516b:	39 06                	cmp    %eax,(%esi)
8010516d:	75 41                	jne    801051b0 <sys_link+0xf0>
8010516f:	83 ec 04             	sub    $0x4,%esp
80105172:	ff 73 04             	pushl  0x4(%ebx)
80105175:	57                   	push   %edi
80105176:	56                   	push   %esi
80105177:	e8 14 d0 ff ff       	call   80102190 <dirlink>
8010517c:	83 c4 10             	add    $0x10,%esp
8010517f:	85 c0                	test   %eax,%eax
80105181:	78 2d                	js     801051b0 <sys_link+0xf0>
  iunlockput(dp);
80105183:	83 ec 0c             	sub    $0xc,%esp
80105186:	56                   	push   %esi
80105187:	e8 94 ca ff ff       	call   80101c20 <iunlockput>
  iput(ip);
8010518c:	89 1c 24             	mov    %ebx,(%esp)
8010518f:	e8 1c c9 ff ff       	call   80101ab0 <iput>
  end_op();
80105194:	e8 27 de ff ff       	call   80102fc0 <end_op>
  return 0;
80105199:	83 c4 10             	add    $0x10,%esp
8010519c:	31 c0                	xor    %eax,%eax
}
8010519e:	8d 65 f4             	lea    -0xc(%ebp),%esp
801051a1:	5b                   	pop    %ebx
801051a2:	5e                   	pop    %esi
801051a3:	5f                   	pop    %edi
801051a4:	5d                   	pop    %ebp
801051a5:	c3                   	ret    
801051a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801051ad:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(dp);
801051b0:	83 ec 0c             	sub    $0xc,%esp
801051b3:	56                   	push   %esi
801051b4:	e8 67 ca ff ff       	call   80101c20 <iunlockput>
    goto bad;
801051b9:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
801051bc:	83 ec 0c             	sub    $0xc,%esp
801051bf:	53                   	push   %ebx
801051c0:	e8 bb c7 ff ff       	call   80101980 <ilock>
  ip->nlink--;
801051c5:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801051ca:	89 1c 24             	mov    %ebx,(%esp)
801051cd:	e8 ee c6 ff ff       	call   801018c0 <iupdate>
  iunlockput(ip);
801051d2:	89 1c 24             	mov    %ebx,(%esp)
801051d5:	e8 46 ca ff ff       	call   80101c20 <iunlockput>
  end_op();
801051da:	e8 e1 dd ff ff       	call   80102fc0 <end_op>
  return -1;
801051df:	83 c4 10             	add    $0x10,%esp
801051e2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801051e7:	eb b5                	jmp    8010519e <sys_link+0xde>
    iunlockput(ip);
801051e9:	83 ec 0c             	sub    $0xc,%esp
801051ec:	53                   	push   %ebx
801051ed:	e8 2e ca ff ff       	call   80101c20 <iunlockput>
    end_op();
801051f2:	e8 c9 dd ff ff       	call   80102fc0 <end_op>
    return -1;
801051f7:	83 c4 10             	add    $0x10,%esp
801051fa:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801051ff:	eb 9d                	jmp    8010519e <sys_link+0xde>
    end_op();
80105201:	e8 ba dd ff ff       	call   80102fc0 <end_op>
    return -1;
80105206:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010520b:	eb 91                	jmp    8010519e <sys_link+0xde>
8010520d:	8d 76 00             	lea    0x0(%esi),%esi

80105210 <sys_unlink>:
{
80105210:	f3 0f 1e fb          	endbr32 
80105214:	55                   	push   %ebp
80105215:	89 e5                	mov    %esp,%ebp
80105217:	57                   	push   %edi
80105218:	56                   	push   %esi
  if(argstr(0, &path) < 0)
80105219:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
8010521c:	53                   	push   %ebx
8010521d:	83 ec 54             	sub    $0x54,%esp
  if(argstr(0, &path) < 0)
80105220:	50                   	push   %eax
80105221:	6a 00                	push   $0x0
80105223:	e8 08 fa ff ff       	call   80104c30 <argstr>
80105228:	83 c4 10             	add    $0x10,%esp
8010522b:	85 c0                	test   %eax,%eax
8010522d:	0f 88 7d 01 00 00    	js     801053b0 <sys_unlink+0x1a0>
  begin_op();
80105233:	e8 18 dd ff ff       	call   80102f50 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105238:	8d 5d ca             	lea    -0x36(%ebp),%ebx
8010523b:	83 ec 08             	sub    $0x8,%esp
8010523e:	53                   	push   %ebx
8010523f:	ff 75 c0             	pushl  -0x40(%ebp)
80105242:	e8 29 d0 ff ff       	call   80102270 <nameiparent>
80105247:	83 c4 10             	add    $0x10,%esp
8010524a:	89 c6                	mov    %eax,%esi
8010524c:	85 c0                	test   %eax,%eax
8010524e:	0f 84 66 01 00 00    	je     801053ba <sys_unlink+0x1aa>
  ilock(dp);
80105254:	83 ec 0c             	sub    $0xc,%esp
80105257:	50                   	push   %eax
80105258:	e8 23 c7 ff ff       	call   80101980 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
8010525d:	58                   	pop    %eax
8010525e:	5a                   	pop    %edx
8010525f:	68 bc 7a 10 80       	push   $0x80107abc
80105264:	53                   	push   %ebx
80105265:	e8 46 cc ff ff       	call   80101eb0 <namecmp>
8010526a:	83 c4 10             	add    $0x10,%esp
8010526d:	85 c0                	test   %eax,%eax
8010526f:	0f 84 03 01 00 00    	je     80105378 <sys_unlink+0x168>
80105275:	83 ec 08             	sub    $0x8,%esp
80105278:	68 bb 7a 10 80       	push   $0x80107abb
8010527d:	53                   	push   %ebx
8010527e:	e8 2d cc ff ff       	call   80101eb0 <namecmp>
80105283:	83 c4 10             	add    $0x10,%esp
80105286:	85 c0                	test   %eax,%eax
80105288:	0f 84 ea 00 00 00    	je     80105378 <sys_unlink+0x168>
  if((ip = dirlookup(dp, name, &off)) == 0)
8010528e:	83 ec 04             	sub    $0x4,%esp
80105291:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80105294:	50                   	push   %eax
80105295:	53                   	push   %ebx
80105296:	56                   	push   %esi
80105297:	e8 34 cc ff ff       	call   80101ed0 <dirlookup>
8010529c:	83 c4 10             	add    $0x10,%esp
8010529f:	89 c3                	mov    %eax,%ebx
801052a1:	85 c0                	test   %eax,%eax
801052a3:	0f 84 cf 00 00 00    	je     80105378 <sys_unlink+0x168>
  ilock(ip);
801052a9:	83 ec 0c             	sub    $0xc,%esp
801052ac:	50                   	push   %eax
801052ad:	e8 ce c6 ff ff       	call   80101980 <ilock>
  if(ip->nlink < 1)
801052b2:	83 c4 10             	add    $0x10,%esp
801052b5:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801052ba:	0f 8e 23 01 00 00    	jle    801053e3 <sys_unlink+0x1d3>
  if(ip->type == T_DIR && !isdirempty(ip)){
801052c0:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801052c5:	8d 7d d8             	lea    -0x28(%ebp),%edi
801052c8:	74 66                	je     80105330 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
801052ca:	83 ec 04             	sub    $0x4,%esp
801052cd:	6a 10                	push   $0x10
801052cf:	6a 00                	push   $0x0
801052d1:	57                   	push   %edi
801052d2:	e8 c9 f5 ff ff       	call   801048a0 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801052d7:	6a 10                	push   $0x10
801052d9:	ff 75 c4             	pushl  -0x3c(%ebp)
801052dc:	57                   	push   %edi
801052dd:	56                   	push   %esi
801052de:	e8 9d ca ff ff       	call   80101d80 <writei>
801052e3:	83 c4 20             	add    $0x20,%esp
801052e6:	83 f8 10             	cmp    $0x10,%eax
801052e9:	0f 85 e7 00 00 00    	jne    801053d6 <sys_unlink+0x1c6>
  if(ip->type == T_DIR){
801052ef:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801052f4:	0f 84 96 00 00 00    	je     80105390 <sys_unlink+0x180>
  iunlockput(dp);
801052fa:	83 ec 0c             	sub    $0xc,%esp
801052fd:	56                   	push   %esi
801052fe:	e8 1d c9 ff ff       	call   80101c20 <iunlockput>
  ip->nlink--;
80105303:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105308:	89 1c 24             	mov    %ebx,(%esp)
8010530b:	e8 b0 c5 ff ff       	call   801018c0 <iupdate>
  iunlockput(ip);
80105310:	89 1c 24             	mov    %ebx,(%esp)
80105313:	e8 08 c9 ff ff       	call   80101c20 <iunlockput>
  end_op();
80105318:	e8 a3 dc ff ff       	call   80102fc0 <end_op>
  return 0;
8010531d:	83 c4 10             	add    $0x10,%esp
80105320:	31 c0                	xor    %eax,%eax
}
80105322:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105325:	5b                   	pop    %ebx
80105326:	5e                   	pop    %esi
80105327:	5f                   	pop    %edi
80105328:	5d                   	pop    %ebp
80105329:	c3                   	ret    
8010532a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105330:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80105334:	76 94                	jbe    801052ca <sys_unlink+0xba>
80105336:	ba 20 00 00 00       	mov    $0x20,%edx
8010533b:	eb 0b                	jmp    80105348 <sys_unlink+0x138>
8010533d:	8d 76 00             	lea    0x0(%esi),%esi
80105340:	83 c2 10             	add    $0x10,%edx
80105343:	39 53 58             	cmp    %edx,0x58(%ebx)
80105346:	76 82                	jbe    801052ca <sys_unlink+0xba>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105348:	6a 10                	push   $0x10
8010534a:	52                   	push   %edx
8010534b:	57                   	push   %edi
8010534c:	53                   	push   %ebx
8010534d:	89 55 b4             	mov    %edx,-0x4c(%ebp)
80105350:	e8 2b c9 ff ff       	call   80101c80 <readi>
80105355:	83 c4 10             	add    $0x10,%esp
80105358:	8b 55 b4             	mov    -0x4c(%ebp),%edx
8010535b:	83 f8 10             	cmp    $0x10,%eax
8010535e:	75 69                	jne    801053c9 <sys_unlink+0x1b9>
    if(de.inum != 0)
80105360:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80105365:	74 d9                	je     80105340 <sys_unlink+0x130>
    iunlockput(ip);
80105367:	83 ec 0c             	sub    $0xc,%esp
8010536a:	53                   	push   %ebx
8010536b:	e8 b0 c8 ff ff       	call   80101c20 <iunlockput>
    goto bad;
80105370:	83 c4 10             	add    $0x10,%esp
80105373:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105377:	90                   	nop
  iunlockput(dp);
80105378:	83 ec 0c             	sub    $0xc,%esp
8010537b:	56                   	push   %esi
8010537c:	e8 9f c8 ff ff       	call   80101c20 <iunlockput>
  end_op();
80105381:	e8 3a dc ff ff       	call   80102fc0 <end_op>
  return -1;
80105386:	83 c4 10             	add    $0x10,%esp
80105389:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010538e:	eb 92                	jmp    80105322 <sys_unlink+0x112>
    iupdate(dp);
80105390:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
80105393:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
80105398:	56                   	push   %esi
80105399:	e8 22 c5 ff ff       	call   801018c0 <iupdate>
8010539e:	83 c4 10             	add    $0x10,%esp
801053a1:	e9 54 ff ff ff       	jmp    801052fa <sys_unlink+0xea>
801053a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801053ad:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
801053b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801053b5:	e9 68 ff ff ff       	jmp    80105322 <sys_unlink+0x112>
    end_op();
801053ba:	e8 01 dc ff ff       	call   80102fc0 <end_op>
    return -1;
801053bf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801053c4:	e9 59 ff ff ff       	jmp    80105322 <sys_unlink+0x112>
      panic("isdirempty: readi");
801053c9:	83 ec 0c             	sub    $0xc,%esp
801053cc:	68 e0 7a 10 80       	push   $0x80107ae0
801053d1:	e8 ba af ff ff       	call   80100390 <panic>
    panic("unlink: writei");
801053d6:	83 ec 0c             	sub    $0xc,%esp
801053d9:	68 f2 7a 10 80       	push   $0x80107af2
801053de:	e8 ad af ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
801053e3:	83 ec 0c             	sub    $0xc,%esp
801053e6:	68 ce 7a 10 80       	push   $0x80107ace
801053eb:	e8 a0 af ff ff       	call   80100390 <panic>

801053f0 <sys_open>:

int
sys_open(void)
{
801053f0:	f3 0f 1e fb          	endbr32 
801053f4:	55                   	push   %ebp
801053f5:	89 e5                	mov    %esp,%ebp
801053f7:	57                   	push   %edi
801053f8:	56                   	push   %esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801053f9:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
801053fc:	53                   	push   %ebx
801053fd:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105400:	50                   	push   %eax
80105401:	6a 00                	push   $0x0
80105403:	e8 28 f8 ff ff       	call   80104c30 <argstr>
80105408:	83 c4 10             	add    $0x10,%esp
8010540b:	85 c0                	test   %eax,%eax
8010540d:	0f 88 8a 00 00 00    	js     8010549d <sys_open+0xad>
80105413:	83 ec 08             	sub    $0x8,%esp
80105416:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105419:	50                   	push   %eax
8010541a:	6a 01                	push   $0x1
8010541c:	e8 5f f7 ff ff       	call   80104b80 <argint>
80105421:	83 c4 10             	add    $0x10,%esp
80105424:	85 c0                	test   %eax,%eax
80105426:	78 75                	js     8010549d <sys_open+0xad>
    return -1;

  begin_op();
80105428:	e8 23 db ff ff       	call   80102f50 <begin_op>

  if(omode & O_CREATE){
8010542d:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80105431:	75 75                	jne    801054a8 <sys_open+0xb8>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80105433:	83 ec 0c             	sub    $0xc,%esp
80105436:	ff 75 e0             	pushl  -0x20(%ebp)
80105439:	e8 12 ce ff ff       	call   80102250 <namei>
8010543e:	83 c4 10             	add    $0x10,%esp
80105441:	89 c6                	mov    %eax,%esi
80105443:	85 c0                	test   %eax,%eax
80105445:	74 7e                	je     801054c5 <sys_open+0xd5>
      end_op();
      return -1;
    }
    ilock(ip);
80105447:	83 ec 0c             	sub    $0xc,%esp
8010544a:	50                   	push   %eax
8010544b:	e8 30 c5 ff ff       	call   80101980 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105450:	83 c4 10             	add    $0x10,%esp
80105453:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105458:	0f 84 c2 00 00 00    	je     80105520 <sys_open+0x130>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
8010545e:	e8 bd bb ff ff       	call   80101020 <filealloc>
80105463:	89 c7                	mov    %eax,%edi
80105465:	85 c0                	test   %eax,%eax
80105467:	74 23                	je     8010548c <sys_open+0x9c>
  struct proc *curproc = myproc();
80105469:	e8 22 e7 ff ff       	call   80103b90 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010546e:	31 db                	xor    %ebx,%ebx
    if(curproc->ofile[fd] == 0){
80105470:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105474:	85 d2                	test   %edx,%edx
80105476:	74 60                	je     801054d8 <sys_open+0xe8>
  for(fd = 0; fd < NOFILE; fd++){
80105478:	83 c3 01             	add    $0x1,%ebx
8010547b:	83 fb 10             	cmp    $0x10,%ebx
8010547e:	75 f0                	jne    80105470 <sys_open+0x80>
    if(f)
      fileclose(f);
80105480:	83 ec 0c             	sub    $0xc,%esp
80105483:	57                   	push   %edi
80105484:	e8 57 bc ff ff       	call   801010e0 <fileclose>
80105489:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
8010548c:	83 ec 0c             	sub    $0xc,%esp
8010548f:	56                   	push   %esi
80105490:	e8 8b c7 ff ff       	call   80101c20 <iunlockput>
    end_op();
80105495:	e8 26 db ff ff       	call   80102fc0 <end_op>
    return -1;
8010549a:	83 c4 10             	add    $0x10,%esp
8010549d:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801054a2:	eb 6d                	jmp    80105511 <sys_open+0x121>
801054a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = create(path, T_FILE, 0, 0);
801054a8:	83 ec 0c             	sub    $0xc,%esp
801054ab:	8b 45 e0             	mov    -0x20(%ebp),%eax
801054ae:	31 c9                	xor    %ecx,%ecx
801054b0:	ba 02 00 00 00       	mov    $0x2,%edx
801054b5:	6a 00                	push   $0x0
801054b7:	e8 24 f8 ff ff       	call   80104ce0 <create>
    if(ip == 0){
801054bc:	83 c4 10             	add    $0x10,%esp
    ip = create(path, T_FILE, 0, 0);
801054bf:	89 c6                	mov    %eax,%esi
    if(ip == 0){
801054c1:	85 c0                	test   %eax,%eax
801054c3:	75 99                	jne    8010545e <sys_open+0x6e>
      end_op();
801054c5:	e8 f6 da ff ff       	call   80102fc0 <end_op>
      return -1;
801054ca:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801054cf:	eb 40                	jmp    80105511 <sys_open+0x121>
801054d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }
  iunlock(ip);
801054d8:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
801054db:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
801054df:	56                   	push   %esi
801054e0:	e8 7b c5 ff ff       	call   80101a60 <iunlock>
  end_op();
801054e5:	e8 d6 da ff ff       	call   80102fc0 <end_op>

  f->type = FD_INODE;
801054ea:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
801054f0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801054f3:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
801054f6:	89 77 10             	mov    %esi,0x10(%edi)
  f->readable = !(omode & O_WRONLY);
801054f9:	89 d0                	mov    %edx,%eax
  f->off = 0;
801054fb:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
80105502:	f7 d0                	not    %eax
80105504:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105507:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
8010550a:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010550d:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
80105511:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105514:	89 d8                	mov    %ebx,%eax
80105516:	5b                   	pop    %ebx
80105517:	5e                   	pop    %esi
80105518:	5f                   	pop    %edi
80105519:	5d                   	pop    %ebp
8010551a:	c3                   	ret    
8010551b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010551f:	90                   	nop
    if(ip->type == T_DIR && omode != O_RDONLY){
80105520:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80105523:	85 c9                	test   %ecx,%ecx
80105525:	0f 84 33 ff ff ff    	je     8010545e <sys_open+0x6e>
8010552b:	e9 5c ff ff ff       	jmp    8010548c <sys_open+0x9c>

80105530 <sys_mkdir>:

int
sys_mkdir(void)
{
80105530:	f3 0f 1e fb          	endbr32 
80105534:	55                   	push   %ebp
80105535:	89 e5                	mov    %esp,%ebp
80105537:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
8010553a:	e8 11 da ff ff       	call   80102f50 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
8010553f:	83 ec 08             	sub    $0x8,%esp
80105542:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105545:	50                   	push   %eax
80105546:	6a 00                	push   $0x0
80105548:	e8 e3 f6 ff ff       	call   80104c30 <argstr>
8010554d:	83 c4 10             	add    $0x10,%esp
80105550:	85 c0                	test   %eax,%eax
80105552:	78 34                	js     80105588 <sys_mkdir+0x58>
80105554:	83 ec 0c             	sub    $0xc,%esp
80105557:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010555a:	31 c9                	xor    %ecx,%ecx
8010555c:	ba 01 00 00 00       	mov    $0x1,%edx
80105561:	6a 00                	push   $0x0
80105563:	e8 78 f7 ff ff       	call   80104ce0 <create>
80105568:	83 c4 10             	add    $0x10,%esp
8010556b:	85 c0                	test   %eax,%eax
8010556d:	74 19                	je     80105588 <sys_mkdir+0x58>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010556f:	83 ec 0c             	sub    $0xc,%esp
80105572:	50                   	push   %eax
80105573:	e8 a8 c6 ff ff       	call   80101c20 <iunlockput>
  end_op();
80105578:	e8 43 da ff ff       	call   80102fc0 <end_op>
  return 0;
8010557d:	83 c4 10             	add    $0x10,%esp
80105580:	31 c0                	xor    %eax,%eax
}
80105582:	c9                   	leave  
80105583:	c3                   	ret    
80105584:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    end_op();
80105588:	e8 33 da ff ff       	call   80102fc0 <end_op>
    return -1;
8010558d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105592:	c9                   	leave  
80105593:	c3                   	ret    
80105594:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010559b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010559f:	90                   	nop

801055a0 <sys_mknod>:

int
sys_mknod(void)
{
801055a0:	f3 0f 1e fb          	endbr32 
801055a4:	55                   	push   %ebp
801055a5:	89 e5                	mov    %esp,%ebp
801055a7:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
801055aa:	e8 a1 d9 ff ff       	call   80102f50 <begin_op>
  if((argstr(0, &path)) < 0 ||
801055af:	83 ec 08             	sub    $0x8,%esp
801055b2:	8d 45 ec             	lea    -0x14(%ebp),%eax
801055b5:	50                   	push   %eax
801055b6:	6a 00                	push   $0x0
801055b8:	e8 73 f6 ff ff       	call   80104c30 <argstr>
801055bd:	83 c4 10             	add    $0x10,%esp
801055c0:	85 c0                	test   %eax,%eax
801055c2:	78 64                	js     80105628 <sys_mknod+0x88>
     argint(1, &major) < 0 ||
801055c4:	83 ec 08             	sub    $0x8,%esp
801055c7:	8d 45 f0             	lea    -0x10(%ebp),%eax
801055ca:	50                   	push   %eax
801055cb:	6a 01                	push   $0x1
801055cd:	e8 ae f5 ff ff       	call   80104b80 <argint>
  if((argstr(0, &path)) < 0 ||
801055d2:	83 c4 10             	add    $0x10,%esp
801055d5:	85 c0                	test   %eax,%eax
801055d7:	78 4f                	js     80105628 <sys_mknod+0x88>
     argint(2, &minor) < 0 ||
801055d9:	83 ec 08             	sub    $0x8,%esp
801055dc:	8d 45 f4             	lea    -0xc(%ebp),%eax
801055df:	50                   	push   %eax
801055e0:	6a 02                	push   $0x2
801055e2:	e8 99 f5 ff ff       	call   80104b80 <argint>
     argint(1, &major) < 0 ||
801055e7:	83 c4 10             	add    $0x10,%esp
801055ea:	85 c0                	test   %eax,%eax
801055ec:	78 3a                	js     80105628 <sys_mknod+0x88>
     (ip = create(path, T_DEV, major, minor)) == 0){
801055ee:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
801055f2:	83 ec 0c             	sub    $0xc,%esp
801055f5:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
801055f9:	ba 03 00 00 00       	mov    $0x3,%edx
801055fe:	50                   	push   %eax
801055ff:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105602:	e8 d9 f6 ff ff       	call   80104ce0 <create>
     argint(2, &minor) < 0 ||
80105607:	83 c4 10             	add    $0x10,%esp
8010560a:	85 c0                	test   %eax,%eax
8010560c:	74 1a                	je     80105628 <sys_mknod+0x88>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010560e:	83 ec 0c             	sub    $0xc,%esp
80105611:	50                   	push   %eax
80105612:	e8 09 c6 ff ff       	call   80101c20 <iunlockput>
  end_op();
80105617:	e8 a4 d9 ff ff       	call   80102fc0 <end_op>
  return 0;
8010561c:	83 c4 10             	add    $0x10,%esp
8010561f:	31 c0                	xor    %eax,%eax
}
80105621:	c9                   	leave  
80105622:	c3                   	ret    
80105623:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105627:	90                   	nop
    end_op();
80105628:	e8 93 d9 ff ff       	call   80102fc0 <end_op>
    return -1;
8010562d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105632:	c9                   	leave  
80105633:	c3                   	ret    
80105634:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010563b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010563f:	90                   	nop

80105640 <sys_chdir>:

int
sys_chdir(void)
{
80105640:	f3 0f 1e fb          	endbr32 
80105644:	55                   	push   %ebp
80105645:	89 e5                	mov    %esp,%ebp
80105647:	56                   	push   %esi
80105648:	53                   	push   %ebx
80105649:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
8010564c:	e8 3f e5 ff ff       	call   80103b90 <myproc>
80105651:	89 c6                	mov    %eax,%esi
  
  begin_op();
80105653:	e8 f8 d8 ff ff       	call   80102f50 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105658:	83 ec 08             	sub    $0x8,%esp
8010565b:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010565e:	50                   	push   %eax
8010565f:	6a 00                	push   $0x0
80105661:	e8 ca f5 ff ff       	call   80104c30 <argstr>
80105666:	83 c4 10             	add    $0x10,%esp
80105669:	85 c0                	test   %eax,%eax
8010566b:	78 73                	js     801056e0 <sys_chdir+0xa0>
8010566d:	83 ec 0c             	sub    $0xc,%esp
80105670:	ff 75 f4             	pushl  -0xc(%ebp)
80105673:	e8 d8 cb ff ff       	call   80102250 <namei>
80105678:	83 c4 10             	add    $0x10,%esp
8010567b:	89 c3                	mov    %eax,%ebx
8010567d:	85 c0                	test   %eax,%eax
8010567f:	74 5f                	je     801056e0 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
80105681:	83 ec 0c             	sub    $0xc,%esp
80105684:	50                   	push   %eax
80105685:	e8 f6 c2 ff ff       	call   80101980 <ilock>
  if(ip->type != T_DIR){
8010568a:	83 c4 10             	add    $0x10,%esp
8010568d:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105692:	75 2c                	jne    801056c0 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105694:	83 ec 0c             	sub    $0xc,%esp
80105697:	53                   	push   %ebx
80105698:	e8 c3 c3 ff ff       	call   80101a60 <iunlock>
  iput(curproc->cwd);
8010569d:	58                   	pop    %eax
8010569e:	ff 76 68             	pushl  0x68(%esi)
801056a1:	e8 0a c4 ff ff       	call   80101ab0 <iput>
  end_op();
801056a6:	e8 15 d9 ff ff       	call   80102fc0 <end_op>
  curproc->cwd = ip;
801056ab:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
801056ae:	83 c4 10             	add    $0x10,%esp
801056b1:	31 c0                	xor    %eax,%eax
}
801056b3:	8d 65 f8             	lea    -0x8(%ebp),%esp
801056b6:	5b                   	pop    %ebx
801056b7:	5e                   	pop    %esi
801056b8:	5d                   	pop    %ebp
801056b9:	c3                   	ret    
801056ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(ip);
801056c0:	83 ec 0c             	sub    $0xc,%esp
801056c3:	53                   	push   %ebx
801056c4:	e8 57 c5 ff ff       	call   80101c20 <iunlockput>
    end_op();
801056c9:	e8 f2 d8 ff ff       	call   80102fc0 <end_op>
    return -1;
801056ce:	83 c4 10             	add    $0x10,%esp
801056d1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801056d6:	eb db                	jmp    801056b3 <sys_chdir+0x73>
801056d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801056df:	90                   	nop
    end_op();
801056e0:	e8 db d8 ff ff       	call   80102fc0 <end_op>
    return -1;
801056e5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801056ea:	eb c7                	jmp    801056b3 <sys_chdir+0x73>
801056ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801056f0 <sys_exec>:

int
sys_exec(void)
{
801056f0:	f3 0f 1e fb          	endbr32 
801056f4:	55                   	push   %ebp
801056f5:	89 e5                	mov    %esp,%ebp
801056f7:	57                   	push   %edi
801056f8:	56                   	push   %esi
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801056f9:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
801056ff:	53                   	push   %ebx
80105700:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105706:	50                   	push   %eax
80105707:	6a 00                	push   $0x0
80105709:	e8 22 f5 ff ff       	call   80104c30 <argstr>
8010570e:	83 c4 10             	add    $0x10,%esp
80105711:	85 c0                	test   %eax,%eax
80105713:	0f 88 8b 00 00 00    	js     801057a4 <sys_exec+0xb4>
80105719:	83 ec 08             	sub    $0x8,%esp
8010571c:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
80105722:	50                   	push   %eax
80105723:	6a 01                	push   $0x1
80105725:	e8 56 f4 ff ff       	call   80104b80 <argint>
8010572a:	83 c4 10             	add    $0x10,%esp
8010572d:	85 c0                	test   %eax,%eax
8010572f:	78 73                	js     801057a4 <sys_exec+0xb4>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80105731:	83 ec 04             	sub    $0x4,%esp
80105734:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
  for(i=0;; i++){
8010573a:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
8010573c:	68 80 00 00 00       	push   $0x80
80105741:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
80105747:	6a 00                	push   $0x0
80105749:	50                   	push   %eax
8010574a:	e8 51 f1 ff ff       	call   801048a0 <memset>
8010574f:	83 c4 10             	add    $0x10,%esp
80105752:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105758:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
8010575e:	8d 34 9d 00 00 00 00 	lea    0x0(,%ebx,4),%esi
80105765:	83 ec 08             	sub    $0x8,%esp
80105768:	57                   	push   %edi
80105769:	01 f0                	add    %esi,%eax
8010576b:	50                   	push   %eax
8010576c:	e8 6f f3 ff ff       	call   80104ae0 <fetchint>
80105771:	83 c4 10             	add    $0x10,%esp
80105774:	85 c0                	test   %eax,%eax
80105776:	78 2c                	js     801057a4 <sys_exec+0xb4>
      return -1;
    if(uarg == 0){
80105778:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
8010577e:	85 c0                	test   %eax,%eax
80105780:	74 36                	je     801057b8 <sys_exec+0xc8>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105782:	8d 8d 68 ff ff ff    	lea    -0x98(%ebp),%ecx
80105788:	83 ec 08             	sub    $0x8,%esp
8010578b:	8d 14 31             	lea    (%ecx,%esi,1),%edx
8010578e:	52                   	push   %edx
8010578f:	50                   	push   %eax
80105790:	e8 8b f3 ff ff       	call   80104b20 <fetchstr>
80105795:	83 c4 10             	add    $0x10,%esp
80105798:	85 c0                	test   %eax,%eax
8010579a:	78 08                	js     801057a4 <sys_exec+0xb4>
  for(i=0;; i++){
8010579c:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
8010579f:	83 fb 20             	cmp    $0x20,%ebx
801057a2:	75 b4                	jne    80105758 <sys_exec+0x68>
      return -1;
  }
  return exec(path, argv);
}
801057a4:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
801057a7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801057ac:	5b                   	pop    %ebx
801057ad:	5e                   	pop    %esi
801057ae:	5f                   	pop    %edi
801057af:	5d                   	pop    %ebp
801057b0:	c3                   	ret    
801057b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return exec(path, argv);
801057b8:	83 ec 08             	sub    $0x8,%esp
801057bb:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
      argv[i] = 0;
801057c1:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
801057c8:	00 00 00 00 
  return exec(path, argv);
801057cc:	50                   	push   %eax
801057cd:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
801057d3:	e8 c8 b4 ff ff       	call   80100ca0 <exec>
801057d8:	83 c4 10             	add    $0x10,%esp
}
801057db:	8d 65 f4             	lea    -0xc(%ebp),%esp
801057de:	5b                   	pop    %ebx
801057df:	5e                   	pop    %esi
801057e0:	5f                   	pop    %edi
801057e1:	5d                   	pop    %ebp
801057e2:	c3                   	ret    
801057e3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801057ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801057f0 <sys_pipe>:

int
sys_pipe(void)
{
801057f0:	f3 0f 1e fb          	endbr32 
801057f4:	55                   	push   %ebp
801057f5:	89 e5                	mov    %esp,%ebp
801057f7:	57                   	push   %edi
801057f8:	56                   	push   %esi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
801057f9:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
801057fc:	53                   	push   %ebx
801057fd:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105800:	6a 08                	push   $0x8
80105802:	50                   	push   %eax
80105803:	6a 00                	push   $0x0
80105805:	e8 c6 f3 ff ff       	call   80104bd0 <argptr>
8010580a:	83 c4 10             	add    $0x10,%esp
8010580d:	85 c0                	test   %eax,%eax
8010580f:	78 4e                	js     8010585f <sys_pipe+0x6f>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80105811:	83 ec 08             	sub    $0x8,%esp
80105814:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105817:	50                   	push   %eax
80105818:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010581b:	50                   	push   %eax
8010581c:	e8 ef dd ff ff       	call   80103610 <pipealloc>
80105821:	83 c4 10             	add    $0x10,%esp
80105824:	85 c0                	test   %eax,%eax
80105826:	78 37                	js     8010585f <sys_pipe+0x6f>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105828:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
8010582b:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
8010582d:	e8 5e e3 ff ff       	call   80103b90 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105832:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(curproc->ofile[fd] == 0){
80105838:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
8010583c:	85 f6                	test   %esi,%esi
8010583e:	74 30                	je     80105870 <sys_pipe+0x80>
  for(fd = 0; fd < NOFILE; fd++){
80105840:	83 c3 01             	add    $0x1,%ebx
80105843:	83 fb 10             	cmp    $0x10,%ebx
80105846:	75 f0                	jne    80105838 <sys_pipe+0x48>
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
80105848:	83 ec 0c             	sub    $0xc,%esp
8010584b:	ff 75 e0             	pushl  -0x20(%ebp)
8010584e:	e8 8d b8 ff ff       	call   801010e0 <fileclose>
    fileclose(wf);
80105853:	58                   	pop    %eax
80105854:	ff 75 e4             	pushl  -0x1c(%ebp)
80105857:	e8 84 b8 ff ff       	call   801010e0 <fileclose>
    return -1;
8010585c:	83 c4 10             	add    $0x10,%esp
8010585f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105864:	eb 5b                	jmp    801058c1 <sys_pipe+0xd1>
80105866:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010586d:	8d 76 00             	lea    0x0(%esi),%esi
      curproc->ofile[fd] = f;
80105870:	8d 73 08             	lea    0x8(%ebx),%esi
80105873:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105877:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
8010587a:	e8 11 e3 ff ff       	call   80103b90 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010587f:	31 d2                	xor    %edx,%edx
80105881:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80105888:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
8010588c:	85 c9                	test   %ecx,%ecx
8010588e:	74 20                	je     801058b0 <sys_pipe+0xc0>
  for(fd = 0; fd < NOFILE; fd++){
80105890:	83 c2 01             	add    $0x1,%edx
80105893:	83 fa 10             	cmp    $0x10,%edx
80105896:	75 f0                	jne    80105888 <sys_pipe+0x98>
      myproc()->ofile[fd0] = 0;
80105898:	e8 f3 e2 ff ff       	call   80103b90 <myproc>
8010589d:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
801058a4:	00 
801058a5:	eb a1                	jmp    80105848 <sys_pipe+0x58>
801058a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801058ae:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
801058b0:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
  }
  fd[0] = fd0;
801058b4:	8b 45 dc             	mov    -0x24(%ebp),%eax
801058b7:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
801058b9:	8b 45 dc             	mov    -0x24(%ebp),%eax
801058bc:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
801058bf:	31 c0                	xor    %eax,%eax
}
801058c1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801058c4:	5b                   	pop    %ebx
801058c5:	5e                   	pop    %esi
801058c6:	5f                   	pop    %edi
801058c7:	5d                   	pop    %ebp
801058c8:	c3                   	ret    
801058c9:	66 90                	xchg   %ax,%ax
801058cb:	66 90                	xchg   %ax,%ax
801058cd:	66 90                	xchg   %ax,%ax
801058cf:	90                   	nop

801058d0 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
801058d0:	f3 0f 1e fb          	endbr32 
  return fork();
801058d4:	e9 67 e4 ff ff       	jmp    80103d40 <fork>
801058d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801058e0 <sys_exit>:
}

int
sys_exit(void)
{
801058e0:	f3 0f 1e fb          	endbr32 
801058e4:	55                   	push   %ebp
801058e5:	89 e5                	mov    %esp,%ebp
801058e7:	83 ec 08             	sub    $0x8,%esp
  exit();
801058ea:	e8 d1 e6 ff ff       	call   80103fc0 <exit>
  return 0;  // not reached
}
801058ef:	31 c0                	xor    %eax,%eax
801058f1:	c9                   	leave  
801058f2:	c3                   	ret    
801058f3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801058fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105900 <sys_wait>:

int
sys_wait(void)
{
80105900:	f3 0f 1e fb          	endbr32 
  return wait();
80105904:	e9 07 e9 ff ff       	jmp    80104210 <wait>
80105909:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105910 <sys_kill>:
}

int
sys_kill(void)
{
80105910:	f3 0f 1e fb          	endbr32 
80105914:	55                   	push   %ebp
80105915:	89 e5                	mov    %esp,%ebp
80105917:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
8010591a:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010591d:	50                   	push   %eax
8010591e:	6a 00                	push   $0x0
80105920:	e8 5b f2 ff ff       	call   80104b80 <argint>
80105925:	83 c4 10             	add    $0x10,%esp
80105928:	85 c0                	test   %eax,%eax
8010592a:	78 14                	js     80105940 <sys_kill+0x30>
    return -1;
  return kill(pid);
8010592c:	83 ec 0c             	sub    $0xc,%esp
8010592f:	ff 75 f4             	pushl  -0xc(%ebp)
80105932:	e8 39 ea ff ff       	call   80104370 <kill>
80105937:	83 c4 10             	add    $0x10,%esp
}
8010593a:	c9                   	leave  
8010593b:	c3                   	ret    
8010593c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105940:	c9                   	leave  
    return -1;
80105941:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105946:	c3                   	ret    
80105947:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010594e:	66 90                	xchg   %ax,%ax

80105950 <sys_getpid>:

int
sys_getpid(void)
{
80105950:	f3 0f 1e fb          	endbr32 
80105954:	55                   	push   %ebp
80105955:	89 e5                	mov    %esp,%ebp
80105957:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
8010595a:	e8 31 e2 ff ff       	call   80103b90 <myproc>
8010595f:	8b 40 10             	mov    0x10(%eax),%eax
}
80105962:	c9                   	leave  
80105963:	c3                   	ret    
80105964:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010596b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010596f:	90                   	nop

80105970 <sys_sbrk>:

int
sys_sbrk(void)
{
80105970:	f3 0f 1e fb          	endbr32 
80105974:	55                   	push   %ebp
80105975:	89 e5                	mov    %esp,%ebp
80105977:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105978:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
8010597b:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
8010597e:	50                   	push   %eax
8010597f:	6a 00                	push   $0x0
80105981:	e8 fa f1 ff ff       	call   80104b80 <argint>
80105986:	83 c4 10             	add    $0x10,%esp
80105989:	85 c0                	test   %eax,%eax
8010598b:	78 23                	js     801059b0 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
8010598d:	e8 fe e1 ff ff       	call   80103b90 <myproc>
  if(growproc(n) < 0)
80105992:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80105995:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105997:	ff 75 f4             	pushl  -0xc(%ebp)
8010599a:	e8 21 e3 ff ff       	call   80103cc0 <growproc>
8010599f:	83 c4 10             	add    $0x10,%esp
801059a2:	85 c0                	test   %eax,%eax
801059a4:	78 0a                	js     801059b0 <sys_sbrk+0x40>
    return -1;
  return addr;
}
801059a6:	89 d8                	mov    %ebx,%eax
801059a8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801059ab:	c9                   	leave  
801059ac:	c3                   	ret    
801059ad:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
801059b0:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801059b5:	eb ef                	jmp    801059a6 <sys_sbrk+0x36>
801059b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801059be:	66 90                	xchg   %ax,%ax

801059c0 <sys_sleep>:

int
sys_sleep(void)
{
801059c0:	f3 0f 1e fb          	endbr32 
801059c4:	55                   	push   %ebp
801059c5:	89 e5                	mov    %esp,%ebp
801059c7:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
801059c8:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
801059cb:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
801059ce:	50                   	push   %eax
801059cf:	6a 00                	push   $0x0
801059d1:	e8 aa f1 ff ff       	call   80104b80 <argint>
801059d6:	83 c4 10             	add    $0x10,%esp
801059d9:	85 c0                	test   %eax,%eax
801059db:	0f 88 86 00 00 00    	js     80105a67 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
801059e1:	83 ec 0c             	sub    $0xc,%esp
801059e4:	68 80 4d 11 80       	push   $0x80114d80
801059e9:	e8 a2 ed ff ff       	call   80104790 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
801059ee:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
801059f1:	8b 1d c0 55 11 80    	mov    0x801155c0,%ebx
  while(ticks - ticks0 < n){
801059f7:	83 c4 10             	add    $0x10,%esp
801059fa:	85 d2                	test   %edx,%edx
801059fc:	75 23                	jne    80105a21 <sys_sleep+0x61>
801059fe:	eb 50                	jmp    80105a50 <sys_sleep+0x90>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105a00:	83 ec 08             	sub    $0x8,%esp
80105a03:	68 80 4d 11 80       	push   $0x80114d80
80105a08:	68 c0 55 11 80       	push   $0x801155c0
80105a0d:	e8 3e e7 ff ff       	call   80104150 <sleep>
  while(ticks - ticks0 < n){
80105a12:	a1 c0 55 11 80       	mov    0x801155c0,%eax
80105a17:	83 c4 10             	add    $0x10,%esp
80105a1a:	29 d8                	sub    %ebx,%eax
80105a1c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80105a1f:	73 2f                	jae    80105a50 <sys_sleep+0x90>
    if(myproc()->killed){
80105a21:	e8 6a e1 ff ff       	call   80103b90 <myproc>
80105a26:	8b 40 24             	mov    0x24(%eax),%eax
80105a29:	85 c0                	test   %eax,%eax
80105a2b:	74 d3                	je     80105a00 <sys_sleep+0x40>
      release(&tickslock);
80105a2d:	83 ec 0c             	sub    $0xc,%esp
80105a30:	68 80 4d 11 80       	push   $0x80114d80
80105a35:	e8 16 ee ff ff       	call   80104850 <release>
  }
  release(&tickslock);
  return 0;
}
80105a3a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return -1;
80105a3d:	83 c4 10             	add    $0x10,%esp
80105a40:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105a45:	c9                   	leave  
80105a46:	c3                   	ret    
80105a47:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105a4e:	66 90                	xchg   %ax,%ax
  release(&tickslock);
80105a50:	83 ec 0c             	sub    $0xc,%esp
80105a53:	68 80 4d 11 80       	push   $0x80114d80
80105a58:	e8 f3 ed ff ff       	call   80104850 <release>
  return 0;
80105a5d:	83 c4 10             	add    $0x10,%esp
80105a60:	31 c0                	xor    %eax,%eax
}
80105a62:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105a65:	c9                   	leave  
80105a66:	c3                   	ret    
    return -1;
80105a67:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a6c:	eb f4                	jmp    80105a62 <sys_sleep+0xa2>
80105a6e:	66 90                	xchg   %ax,%ax

80105a70 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105a70:	f3 0f 1e fb          	endbr32 
80105a74:	55                   	push   %ebp
80105a75:	89 e5                	mov    %esp,%ebp
80105a77:	53                   	push   %ebx
80105a78:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80105a7b:	68 80 4d 11 80       	push   $0x80114d80
80105a80:	e8 0b ed ff ff       	call   80104790 <acquire>
  xticks = ticks;
80105a85:	8b 1d c0 55 11 80    	mov    0x801155c0,%ebx
  release(&tickslock);
80105a8b:	c7 04 24 80 4d 11 80 	movl   $0x80114d80,(%esp)
80105a92:	e8 b9 ed ff ff       	call   80104850 <release>
  return xticks;
}
80105a97:	89 d8                	mov    %ebx,%eax
80105a99:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105a9c:	c9                   	leave  
80105a9d:	c3                   	ret    
80105a9e:	66 90                	xchg   %ax,%ax

80105aa0 <sys_getyear>:


int sys_getyear(void){
80105aa0:	f3 0f 1e fb          	endbr32 
  return 1975;
}
80105aa4:	b8 b7 07 00 00       	mov    $0x7b7,%eax
80105aa9:	c3                   	ret    
80105aaa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105ab0 <sys_getnextprime>:

int sys_getnextprime(void){
80105ab0:	f3 0f 1e fb          	endbr32 
80105ab4:	55                   	push   %ebp
80105ab5:	89 e5                	mov    %esp,%ebp
80105ab7:	57                   	push   %edi
  number++;
  while(1){
    int flag = 0;
    for(int i = 2; i < number; i++){
      if(number%i == 0)
        flag = 1;
80105ab8:	bf 01 00 00 00       	mov    $0x1,%edi
int sys_getnextprime(void){
80105abd:	56                   	push   %esi
80105abe:	53                   	push   %ebx
80105abf:	83 ec 0c             	sub    $0xc,%esp
  int number = myproc()->tf->ebx; //register after eax
80105ac2:	e8 c9 e0 ff ff       	call   80103b90 <myproc>
80105ac7:	8b 40 18             	mov    0x18(%eax),%eax
80105aca:	8b 58 10             	mov    0x10(%eax),%ebx
  number++;
80105acd:	83 c3 01             	add    $0x1,%ebx
    for(int i = 2; i < number; i++){
80105ad0:	83 fb 02             	cmp    $0x2,%ebx
80105ad3:	7e 28                	jle    80105afd <sys_getnextprime+0x4d>
80105ad5:	8d 76 00             	lea    0x0(%esi),%esi
80105ad8:	b9 02 00 00 00       	mov    $0x2,%ecx
    int flag = 0;
80105add:	31 f6                	xor    %esi,%esi
80105adf:	90                   	nop
      if(number%i == 0)
80105ae0:	89 d8                	mov    %ebx,%eax
80105ae2:	99                   	cltd   
80105ae3:	f7 f9                	idiv   %ecx
        flag = 1;
80105ae5:	85 d2                	test   %edx,%edx
80105ae7:	0f 44 f7             	cmove  %edi,%esi
    for(int i = 2; i < number; i++){
80105aea:	83 c1 01             	add    $0x1,%ecx
80105aed:	39 cb                	cmp    %ecx,%ebx
80105aef:	75 ef                	jne    80105ae0 <sys_getnextprime+0x30>
    }
    if(!flag){
80105af1:	85 f6                	test   %esi,%esi
80105af3:	74 08                	je     80105afd <sys_getnextprime+0x4d>
      return number;
    }
    number++;
80105af5:	83 c3 01             	add    $0x1,%ebx
    for(int i = 2; i < number; i++){
80105af8:	83 fb 02             	cmp    $0x2,%ebx
80105afb:	7f db                	jg     80105ad8 <sys_getnextprime+0x28>
  }
80105afd:	83 c4 0c             	add    $0xc,%esp
80105b00:	89 d8                	mov    %ebx,%eax
80105b02:	5b                   	pop    %ebx
80105b03:	5e                   	pop    %esi
80105b04:	5f                   	pop    %edi
80105b05:	5d                   	pop    %ebp
80105b06:	c3                   	ret    

80105b07 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80105b07:	1e                   	push   %ds
  pushl %es
80105b08:	06                   	push   %es
  pushl %fs
80105b09:	0f a0                	push   %fs
  pushl %gs
80105b0b:	0f a8                	push   %gs
  pushal
80105b0d:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80105b0e:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105b12:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80105b14:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80105b16:	54                   	push   %esp
  call trap
80105b17:	e8 c4 00 00 00       	call   80105be0 <trap>
  addl $4, %esp
80105b1c:	83 c4 04             	add    $0x4,%esp

80105b1f <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80105b1f:	61                   	popa   
  popl %gs
80105b20:	0f a9                	pop    %gs
  popl %fs
80105b22:	0f a1                	pop    %fs
  popl %es
80105b24:	07                   	pop    %es
  popl %ds
80105b25:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80105b26:	83 c4 08             	add    $0x8,%esp
  iret
80105b29:	cf                   	iret   
80105b2a:	66 90                	xchg   %ax,%ax
80105b2c:	66 90                	xchg   %ax,%ax
80105b2e:	66 90                	xchg   %ax,%ax

80105b30 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105b30:	f3 0f 1e fb          	endbr32 
80105b34:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80105b35:	31 c0                	xor    %eax,%eax
{
80105b37:	89 e5                	mov    %esp,%ebp
80105b39:	83 ec 08             	sub    $0x8,%esp
80105b3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105b40:	8b 14 85 08 a0 10 80 	mov    -0x7fef5ff8(,%eax,4),%edx
80105b47:	c7 04 c5 c2 4d 11 80 	movl   $0x8e000008,-0x7feeb23e(,%eax,8)
80105b4e:	08 00 00 8e 
80105b52:	66 89 14 c5 c0 4d 11 	mov    %dx,-0x7feeb240(,%eax,8)
80105b59:	80 
80105b5a:	c1 ea 10             	shr    $0x10,%edx
80105b5d:	66 89 14 c5 c6 4d 11 	mov    %dx,-0x7feeb23a(,%eax,8)
80105b64:	80 
  for(i = 0; i < 256; i++)
80105b65:	83 c0 01             	add    $0x1,%eax
80105b68:	3d 00 01 00 00       	cmp    $0x100,%eax
80105b6d:	75 d1                	jne    80105b40 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
80105b6f:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105b72:	a1 08 a1 10 80       	mov    0x8010a108,%eax
80105b77:	c7 05 c2 4f 11 80 08 	movl   $0xef000008,0x80114fc2
80105b7e:	00 00 ef 
  initlock(&tickslock, "time");
80105b81:	68 01 7b 10 80       	push   $0x80107b01
80105b86:	68 80 4d 11 80       	push   $0x80114d80
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105b8b:	66 a3 c0 4f 11 80    	mov    %ax,0x80114fc0
80105b91:	c1 e8 10             	shr    $0x10,%eax
80105b94:	66 a3 c6 4f 11 80    	mov    %ax,0x80114fc6
  initlock(&tickslock, "time");
80105b9a:	e8 71 ea ff ff       	call   80104610 <initlock>
}
80105b9f:	83 c4 10             	add    $0x10,%esp
80105ba2:	c9                   	leave  
80105ba3:	c3                   	ret    
80105ba4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105bab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105baf:	90                   	nop

80105bb0 <idtinit>:

void
idtinit(void)
{
80105bb0:	f3 0f 1e fb          	endbr32 
80105bb4:	55                   	push   %ebp
  pd[0] = size-1;
80105bb5:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80105bba:	89 e5                	mov    %esp,%ebp
80105bbc:	83 ec 10             	sub    $0x10,%esp
80105bbf:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80105bc3:	b8 c0 4d 11 80       	mov    $0x80114dc0,%eax
80105bc8:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105bcc:	c1 e8 10             	shr    $0x10,%eax
80105bcf:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80105bd3:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105bd6:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80105bd9:	c9                   	leave  
80105bda:	c3                   	ret    
80105bdb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105bdf:	90                   	nop

80105be0 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80105be0:	f3 0f 1e fb          	endbr32 
80105be4:	55                   	push   %ebp
80105be5:	89 e5                	mov    %esp,%ebp
80105be7:	57                   	push   %edi
80105be8:	56                   	push   %esi
80105be9:	53                   	push   %ebx
80105bea:	83 ec 1c             	sub    $0x1c,%esp
80105bed:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
80105bf0:	8b 43 30             	mov    0x30(%ebx),%eax
80105bf3:	83 f8 40             	cmp    $0x40,%eax
80105bf6:	0f 84 bc 01 00 00    	je     80105db8 <trap+0x1d8>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80105bfc:	83 e8 20             	sub    $0x20,%eax
80105bff:	83 f8 1f             	cmp    $0x1f,%eax
80105c02:	77 08                	ja     80105c0c <trap+0x2c>
80105c04:	3e ff 24 85 a8 7b 10 	notrack jmp *-0x7fef8458(,%eax,4)
80105c0b:	80 
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
80105c0c:	e8 7f df ff ff       	call   80103b90 <myproc>
80105c11:	8b 7b 38             	mov    0x38(%ebx),%edi
80105c14:	85 c0                	test   %eax,%eax
80105c16:	0f 84 eb 01 00 00    	je     80105e07 <trap+0x227>
80105c1c:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
80105c20:	0f 84 e1 01 00 00    	je     80105e07 <trap+0x227>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80105c26:	0f 20 d1             	mov    %cr2,%ecx
80105c29:	89 4d d8             	mov    %ecx,-0x28(%ebp)
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105c2c:	e8 3f df ff ff       	call   80103b70 <cpuid>
80105c31:	8b 73 30             	mov    0x30(%ebx),%esi
80105c34:	89 45 dc             	mov    %eax,-0x24(%ebp)
80105c37:	8b 43 34             	mov    0x34(%ebx),%eax
80105c3a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80105c3d:	e8 4e df ff ff       	call   80103b90 <myproc>
80105c42:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105c45:	e8 46 df ff ff       	call   80103b90 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105c4a:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80105c4d:	8b 55 dc             	mov    -0x24(%ebp),%edx
80105c50:	51                   	push   %ecx
80105c51:	57                   	push   %edi
80105c52:	52                   	push   %edx
80105c53:	ff 75 e4             	pushl  -0x1c(%ebp)
80105c56:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
80105c57:	8b 75 e0             	mov    -0x20(%ebp),%esi
80105c5a:	83 c6 6c             	add    $0x6c,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105c5d:	56                   	push   %esi
80105c5e:	ff 70 10             	pushl  0x10(%eax)
80105c61:	68 64 7b 10 80       	push   $0x80107b64
80105c66:	e8 b5 aa ff ff       	call   80100720 <cprintf>
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
80105c6b:	83 c4 20             	add    $0x20,%esp
80105c6e:	e8 1d df ff ff       	call   80103b90 <myproc>
80105c73:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105c7a:	e8 11 df ff ff       	call   80103b90 <myproc>
80105c7f:	85 c0                	test   %eax,%eax
80105c81:	74 1d                	je     80105ca0 <trap+0xc0>
80105c83:	e8 08 df ff ff       	call   80103b90 <myproc>
80105c88:	8b 50 24             	mov    0x24(%eax),%edx
80105c8b:	85 d2                	test   %edx,%edx
80105c8d:	74 11                	je     80105ca0 <trap+0xc0>
80105c8f:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105c93:	83 e0 03             	and    $0x3,%eax
80105c96:	66 83 f8 03          	cmp    $0x3,%ax
80105c9a:	0f 84 50 01 00 00    	je     80105df0 <trap+0x210>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80105ca0:	e8 eb de ff ff       	call   80103b90 <myproc>
80105ca5:	85 c0                	test   %eax,%eax
80105ca7:	74 0f                	je     80105cb8 <trap+0xd8>
80105ca9:	e8 e2 de ff ff       	call   80103b90 <myproc>
80105cae:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80105cb2:	0f 84 e8 00 00 00    	je     80105da0 <trap+0x1c0>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105cb8:	e8 d3 de ff ff       	call   80103b90 <myproc>
80105cbd:	85 c0                	test   %eax,%eax
80105cbf:	74 1d                	je     80105cde <trap+0xfe>
80105cc1:	e8 ca de ff ff       	call   80103b90 <myproc>
80105cc6:	8b 40 24             	mov    0x24(%eax),%eax
80105cc9:	85 c0                	test   %eax,%eax
80105ccb:	74 11                	je     80105cde <trap+0xfe>
80105ccd:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105cd1:	83 e0 03             	and    $0x3,%eax
80105cd4:	66 83 f8 03          	cmp    $0x3,%ax
80105cd8:	0f 84 03 01 00 00    	je     80105de1 <trap+0x201>
    exit();
}
80105cde:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105ce1:	5b                   	pop    %ebx
80105ce2:	5e                   	pop    %esi
80105ce3:	5f                   	pop    %edi
80105ce4:	5d                   	pop    %ebp
80105ce5:	c3                   	ret    
    ideintr();
80105ce6:	e8 15 c7 ff ff       	call   80102400 <ideintr>
    lapiceoi();
80105ceb:	e8 f0 cd ff ff       	call   80102ae0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105cf0:	e8 9b de ff ff       	call   80103b90 <myproc>
80105cf5:	85 c0                	test   %eax,%eax
80105cf7:	75 8a                	jne    80105c83 <trap+0xa3>
80105cf9:	eb a5                	jmp    80105ca0 <trap+0xc0>
    if(cpuid() == 0){
80105cfb:	e8 70 de ff ff       	call   80103b70 <cpuid>
80105d00:	85 c0                	test   %eax,%eax
80105d02:	75 e7                	jne    80105ceb <trap+0x10b>
      acquire(&tickslock);
80105d04:	83 ec 0c             	sub    $0xc,%esp
80105d07:	68 80 4d 11 80       	push   $0x80114d80
80105d0c:	e8 7f ea ff ff       	call   80104790 <acquire>
      wakeup(&ticks);
80105d11:	c7 04 24 c0 55 11 80 	movl   $0x801155c0,(%esp)
      ticks++;
80105d18:	83 05 c0 55 11 80 01 	addl   $0x1,0x801155c0
      wakeup(&ticks);
80105d1f:	e8 ec e5 ff ff       	call   80104310 <wakeup>
      release(&tickslock);
80105d24:	c7 04 24 80 4d 11 80 	movl   $0x80114d80,(%esp)
80105d2b:	e8 20 eb ff ff       	call   80104850 <release>
80105d30:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
80105d33:	eb b6                	jmp    80105ceb <trap+0x10b>
    kbdintr();
80105d35:	e8 66 cc ff ff       	call   801029a0 <kbdintr>
    lapiceoi();
80105d3a:	e8 a1 cd ff ff       	call   80102ae0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105d3f:	e8 4c de ff ff       	call   80103b90 <myproc>
80105d44:	85 c0                	test   %eax,%eax
80105d46:	0f 85 37 ff ff ff    	jne    80105c83 <trap+0xa3>
80105d4c:	e9 4f ff ff ff       	jmp    80105ca0 <trap+0xc0>
    uartintr();
80105d51:	e8 4a 02 00 00       	call   80105fa0 <uartintr>
    lapiceoi();
80105d56:	e8 85 cd ff ff       	call   80102ae0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105d5b:	e8 30 de ff ff       	call   80103b90 <myproc>
80105d60:	85 c0                	test   %eax,%eax
80105d62:	0f 85 1b ff ff ff    	jne    80105c83 <trap+0xa3>
80105d68:	e9 33 ff ff ff       	jmp    80105ca0 <trap+0xc0>
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80105d6d:	8b 7b 38             	mov    0x38(%ebx),%edi
80105d70:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
80105d74:	e8 f7 dd ff ff       	call   80103b70 <cpuid>
80105d79:	57                   	push   %edi
80105d7a:	56                   	push   %esi
80105d7b:	50                   	push   %eax
80105d7c:	68 0c 7b 10 80       	push   $0x80107b0c
80105d81:	e8 9a a9 ff ff       	call   80100720 <cprintf>
    lapiceoi();
80105d86:	e8 55 cd ff ff       	call   80102ae0 <lapiceoi>
    break;
80105d8b:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105d8e:	e8 fd dd ff ff       	call   80103b90 <myproc>
80105d93:	85 c0                	test   %eax,%eax
80105d95:	0f 85 e8 fe ff ff    	jne    80105c83 <trap+0xa3>
80105d9b:	e9 00 ff ff ff       	jmp    80105ca0 <trap+0xc0>
  if(myproc() && myproc()->state == RUNNING &&
80105da0:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
80105da4:	0f 85 0e ff ff ff    	jne    80105cb8 <trap+0xd8>
    yield();
80105daa:	e8 51 e3 ff ff       	call   80104100 <yield>
80105daf:	e9 04 ff ff ff       	jmp    80105cb8 <trap+0xd8>
80105db4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed)
80105db8:	e8 d3 dd ff ff       	call   80103b90 <myproc>
80105dbd:	8b 70 24             	mov    0x24(%eax),%esi
80105dc0:	85 f6                	test   %esi,%esi
80105dc2:	75 3c                	jne    80105e00 <trap+0x220>
    myproc()->tf = tf;
80105dc4:	e8 c7 dd ff ff       	call   80103b90 <myproc>
80105dc9:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
80105dcc:	e8 9f ee ff ff       	call   80104c70 <syscall>
    if(myproc()->killed)
80105dd1:	e8 ba dd ff ff       	call   80103b90 <myproc>
80105dd6:	8b 48 24             	mov    0x24(%eax),%ecx
80105dd9:	85 c9                	test   %ecx,%ecx
80105ddb:	0f 84 fd fe ff ff    	je     80105cde <trap+0xfe>
}
80105de1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105de4:	5b                   	pop    %ebx
80105de5:	5e                   	pop    %esi
80105de6:	5f                   	pop    %edi
80105de7:	5d                   	pop    %ebp
      exit();
80105de8:	e9 d3 e1 ff ff       	jmp    80103fc0 <exit>
80105ded:	8d 76 00             	lea    0x0(%esi),%esi
    exit();
80105df0:	e8 cb e1 ff ff       	call   80103fc0 <exit>
80105df5:	e9 a6 fe ff ff       	jmp    80105ca0 <trap+0xc0>
80105dfa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
80105e00:	e8 bb e1 ff ff       	call   80103fc0 <exit>
80105e05:	eb bd                	jmp    80105dc4 <trap+0x1e4>
80105e07:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80105e0a:	e8 61 dd ff ff       	call   80103b70 <cpuid>
80105e0f:	83 ec 0c             	sub    $0xc,%esp
80105e12:	56                   	push   %esi
80105e13:	57                   	push   %edi
80105e14:	50                   	push   %eax
80105e15:	ff 73 30             	pushl  0x30(%ebx)
80105e18:	68 30 7b 10 80       	push   $0x80107b30
80105e1d:	e8 fe a8 ff ff       	call   80100720 <cprintf>
      panic("trap");
80105e22:	83 c4 14             	add    $0x14,%esp
80105e25:	68 06 7b 10 80       	push   $0x80107b06
80105e2a:	e8 61 a5 ff ff       	call   80100390 <panic>
80105e2f:	90                   	nop

80105e30 <uartgetc>:
  outb(COM1+0, c);
}

static int
uartgetc(void)
{
80105e30:	f3 0f 1e fb          	endbr32 
  if(!uart)
80105e34:	a1 dc a5 10 80       	mov    0x8010a5dc,%eax
80105e39:	85 c0                	test   %eax,%eax
80105e3b:	74 1b                	je     80105e58 <uartgetc+0x28>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105e3d:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105e42:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80105e43:	a8 01                	test   $0x1,%al
80105e45:	74 11                	je     80105e58 <uartgetc+0x28>
80105e47:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105e4c:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80105e4d:	0f b6 c0             	movzbl %al,%eax
80105e50:	c3                   	ret    
80105e51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105e58:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105e5d:	c3                   	ret    
80105e5e:	66 90                	xchg   %ax,%ax

80105e60 <uartputc.part.0>:
uartputc(int c)
80105e60:	55                   	push   %ebp
80105e61:	89 e5                	mov    %esp,%ebp
80105e63:	57                   	push   %edi
80105e64:	89 c7                	mov    %eax,%edi
80105e66:	56                   	push   %esi
80105e67:	be fd 03 00 00       	mov    $0x3fd,%esi
80105e6c:	53                   	push   %ebx
80105e6d:	bb 80 00 00 00       	mov    $0x80,%ebx
80105e72:	83 ec 0c             	sub    $0xc,%esp
80105e75:	eb 1b                	jmp    80105e92 <uartputc.part.0+0x32>
80105e77:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105e7e:	66 90                	xchg   %ax,%ax
    microdelay(10);
80105e80:	83 ec 0c             	sub    $0xc,%esp
80105e83:	6a 0a                	push   $0xa
80105e85:	e8 76 cc ff ff       	call   80102b00 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105e8a:	83 c4 10             	add    $0x10,%esp
80105e8d:	83 eb 01             	sub    $0x1,%ebx
80105e90:	74 07                	je     80105e99 <uartputc.part.0+0x39>
80105e92:	89 f2                	mov    %esi,%edx
80105e94:	ec                   	in     (%dx),%al
80105e95:	a8 20                	test   $0x20,%al
80105e97:	74 e7                	je     80105e80 <uartputc.part.0+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105e99:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105e9e:	89 f8                	mov    %edi,%eax
80105ea0:	ee                   	out    %al,(%dx)
}
80105ea1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105ea4:	5b                   	pop    %ebx
80105ea5:	5e                   	pop    %esi
80105ea6:	5f                   	pop    %edi
80105ea7:	5d                   	pop    %ebp
80105ea8:	c3                   	ret    
80105ea9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105eb0 <uartinit>:
{
80105eb0:	f3 0f 1e fb          	endbr32 
80105eb4:	55                   	push   %ebp
80105eb5:	31 c9                	xor    %ecx,%ecx
80105eb7:	89 c8                	mov    %ecx,%eax
80105eb9:	89 e5                	mov    %esp,%ebp
80105ebb:	57                   	push   %edi
80105ebc:	56                   	push   %esi
80105ebd:	53                   	push   %ebx
80105ebe:	bb fa 03 00 00       	mov    $0x3fa,%ebx
80105ec3:	89 da                	mov    %ebx,%edx
80105ec5:	83 ec 0c             	sub    $0xc,%esp
80105ec8:	ee                   	out    %al,(%dx)
80105ec9:	bf fb 03 00 00       	mov    $0x3fb,%edi
80105ece:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80105ed3:	89 fa                	mov    %edi,%edx
80105ed5:	ee                   	out    %al,(%dx)
80105ed6:	b8 0c 00 00 00       	mov    $0xc,%eax
80105edb:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105ee0:	ee                   	out    %al,(%dx)
80105ee1:	be f9 03 00 00       	mov    $0x3f9,%esi
80105ee6:	89 c8                	mov    %ecx,%eax
80105ee8:	89 f2                	mov    %esi,%edx
80105eea:	ee                   	out    %al,(%dx)
80105eeb:	b8 03 00 00 00       	mov    $0x3,%eax
80105ef0:	89 fa                	mov    %edi,%edx
80105ef2:	ee                   	out    %al,(%dx)
80105ef3:	ba fc 03 00 00       	mov    $0x3fc,%edx
80105ef8:	89 c8                	mov    %ecx,%eax
80105efa:	ee                   	out    %al,(%dx)
80105efb:	b8 01 00 00 00       	mov    $0x1,%eax
80105f00:	89 f2                	mov    %esi,%edx
80105f02:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105f03:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105f08:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80105f09:	3c ff                	cmp    $0xff,%al
80105f0b:	74 52                	je     80105f5f <uartinit+0xaf>
  uart = 1;
80105f0d:	c7 05 dc a5 10 80 01 	movl   $0x1,0x8010a5dc
80105f14:	00 00 00 
80105f17:	89 da                	mov    %ebx,%edx
80105f19:	ec                   	in     (%dx),%al
80105f1a:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105f1f:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
80105f20:	83 ec 08             	sub    $0x8,%esp
80105f23:	be 76 00 00 00       	mov    $0x76,%esi
  for(p="xv6...\n"; *p; p++)
80105f28:	bb 28 7c 10 80       	mov    $0x80107c28,%ebx
  ioapicenable(IRQ_COM1, 0);
80105f2d:	6a 00                	push   $0x0
80105f2f:	6a 04                	push   $0x4
80105f31:	e8 1a c7 ff ff       	call   80102650 <ioapicenable>
80105f36:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
80105f39:	b8 78 00 00 00       	mov    $0x78,%eax
80105f3e:	eb 04                	jmp    80105f44 <uartinit+0x94>
80105f40:	0f b6 73 01          	movzbl 0x1(%ebx),%esi
  if(!uart)
80105f44:	8b 15 dc a5 10 80    	mov    0x8010a5dc,%edx
80105f4a:	85 d2                	test   %edx,%edx
80105f4c:	74 08                	je     80105f56 <uartinit+0xa6>
    uartputc(*p);
80105f4e:	0f be c0             	movsbl %al,%eax
80105f51:	e8 0a ff ff ff       	call   80105e60 <uartputc.part.0>
  for(p="xv6...\n"; *p; p++)
80105f56:	89 f0                	mov    %esi,%eax
80105f58:	83 c3 01             	add    $0x1,%ebx
80105f5b:	84 c0                	test   %al,%al
80105f5d:	75 e1                	jne    80105f40 <uartinit+0x90>
}
80105f5f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105f62:	5b                   	pop    %ebx
80105f63:	5e                   	pop    %esi
80105f64:	5f                   	pop    %edi
80105f65:	5d                   	pop    %ebp
80105f66:	c3                   	ret    
80105f67:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105f6e:	66 90                	xchg   %ax,%ax

80105f70 <uartputc>:
{
80105f70:	f3 0f 1e fb          	endbr32 
80105f74:	55                   	push   %ebp
  if(!uart)
80105f75:	8b 15 dc a5 10 80    	mov    0x8010a5dc,%edx
{
80105f7b:	89 e5                	mov    %esp,%ebp
80105f7d:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!uart)
80105f80:	85 d2                	test   %edx,%edx
80105f82:	74 0c                	je     80105f90 <uartputc+0x20>
}
80105f84:	5d                   	pop    %ebp
80105f85:	e9 d6 fe ff ff       	jmp    80105e60 <uartputc.part.0>
80105f8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105f90:	5d                   	pop    %ebp
80105f91:	c3                   	ret    
80105f92:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105f99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105fa0 <uartintr>:

void
uartintr(void)
{
80105fa0:	f3 0f 1e fb          	endbr32 
80105fa4:	55                   	push   %ebp
80105fa5:	89 e5                	mov    %esp,%ebp
80105fa7:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80105faa:	68 30 5e 10 80       	push   $0x80105e30
80105faf:	e8 0c aa ff ff       	call   801009c0 <consoleintr>
}
80105fb4:	83 c4 10             	add    $0x10,%esp
80105fb7:	c9                   	leave  
80105fb8:	c3                   	ret    

80105fb9 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80105fb9:	6a 00                	push   $0x0
  pushl $0
80105fbb:	6a 00                	push   $0x0
  jmp alltraps
80105fbd:	e9 45 fb ff ff       	jmp    80105b07 <alltraps>

80105fc2 <vector1>:
.globl vector1
vector1:
  pushl $0
80105fc2:	6a 00                	push   $0x0
  pushl $1
80105fc4:	6a 01                	push   $0x1
  jmp alltraps
80105fc6:	e9 3c fb ff ff       	jmp    80105b07 <alltraps>

80105fcb <vector2>:
.globl vector2
vector2:
  pushl $0
80105fcb:	6a 00                	push   $0x0
  pushl $2
80105fcd:	6a 02                	push   $0x2
  jmp alltraps
80105fcf:	e9 33 fb ff ff       	jmp    80105b07 <alltraps>

80105fd4 <vector3>:
.globl vector3
vector3:
  pushl $0
80105fd4:	6a 00                	push   $0x0
  pushl $3
80105fd6:	6a 03                	push   $0x3
  jmp alltraps
80105fd8:	e9 2a fb ff ff       	jmp    80105b07 <alltraps>

80105fdd <vector4>:
.globl vector4
vector4:
  pushl $0
80105fdd:	6a 00                	push   $0x0
  pushl $4
80105fdf:	6a 04                	push   $0x4
  jmp alltraps
80105fe1:	e9 21 fb ff ff       	jmp    80105b07 <alltraps>

80105fe6 <vector5>:
.globl vector5
vector5:
  pushl $0
80105fe6:	6a 00                	push   $0x0
  pushl $5
80105fe8:	6a 05                	push   $0x5
  jmp alltraps
80105fea:	e9 18 fb ff ff       	jmp    80105b07 <alltraps>

80105fef <vector6>:
.globl vector6
vector6:
  pushl $0
80105fef:	6a 00                	push   $0x0
  pushl $6
80105ff1:	6a 06                	push   $0x6
  jmp alltraps
80105ff3:	e9 0f fb ff ff       	jmp    80105b07 <alltraps>

80105ff8 <vector7>:
.globl vector7
vector7:
  pushl $0
80105ff8:	6a 00                	push   $0x0
  pushl $7
80105ffa:	6a 07                	push   $0x7
  jmp alltraps
80105ffc:	e9 06 fb ff ff       	jmp    80105b07 <alltraps>

80106001 <vector8>:
.globl vector8
vector8:
  pushl $8
80106001:	6a 08                	push   $0x8
  jmp alltraps
80106003:	e9 ff fa ff ff       	jmp    80105b07 <alltraps>

80106008 <vector9>:
.globl vector9
vector9:
  pushl $0
80106008:	6a 00                	push   $0x0
  pushl $9
8010600a:	6a 09                	push   $0x9
  jmp alltraps
8010600c:	e9 f6 fa ff ff       	jmp    80105b07 <alltraps>

80106011 <vector10>:
.globl vector10
vector10:
  pushl $10
80106011:	6a 0a                	push   $0xa
  jmp alltraps
80106013:	e9 ef fa ff ff       	jmp    80105b07 <alltraps>

80106018 <vector11>:
.globl vector11
vector11:
  pushl $11
80106018:	6a 0b                	push   $0xb
  jmp alltraps
8010601a:	e9 e8 fa ff ff       	jmp    80105b07 <alltraps>

8010601f <vector12>:
.globl vector12
vector12:
  pushl $12
8010601f:	6a 0c                	push   $0xc
  jmp alltraps
80106021:	e9 e1 fa ff ff       	jmp    80105b07 <alltraps>

80106026 <vector13>:
.globl vector13
vector13:
  pushl $13
80106026:	6a 0d                	push   $0xd
  jmp alltraps
80106028:	e9 da fa ff ff       	jmp    80105b07 <alltraps>

8010602d <vector14>:
.globl vector14
vector14:
  pushl $14
8010602d:	6a 0e                	push   $0xe
  jmp alltraps
8010602f:	e9 d3 fa ff ff       	jmp    80105b07 <alltraps>

80106034 <vector15>:
.globl vector15
vector15:
  pushl $0
80106034:	6a 00                	push   $0x0
  pushl $15
80106036:	6a 0f                	push   $0xf
  jmp alltraps
80106038:	e9 ca fa ff ff       	jmp    80105b07 <alltraps>

8010603d <vector16>:
.globl vector16
vector16:
  pushl $0
8010603d:	6a 00                	push   $0x0
  pushl $16
8010603f:	6a 10                	push   $0x10
  jmp alltraps
80106041:	e9 c1 fa ff ff       	jmp    80105b07 <alltraps>

80106046 <vector17>:
.globl vector17
vector17:
  pushl $17
80106046:	6a 11                	push   $0x11
  jmp alltraps
80106048:	e9 ba fa ff ff       	jmp    80105b07 <alltraps>

8010604d <vector18>:
.globl vector18
vector18:
  pushl $0
8010604d:	6a 00                	push   $0x0
  pushl $18
8010604f:	6a 12                	push   $0x12
  jmp alltraps
80106051:	e9 b1 fa ff ff       	jmp    80105b07 <alltraps>

80106056 <vector19>:
.globl vector19
vector19:
  pushl $0
80106056:	6a 00                	push   $0x0
  pushl $19
80106058:	6a 13                	push   $0x13
  jmp alltraps
8010605a:	e9 a8 fa ff ff       	jmp    80105b07 <alltraps>

8010605f <vector20>:
.globl vector20
vector20:
  pushl $0
8010605f:	6a 00                	push   $0x0
  pushl $20
80106061:	6a 14                	push   $0x14
  jmp alltraps
80106063:	e9 9f fa ff ff       	jmp    80105b07 <alltraps>

80106068 <vector21>:
.globl vector21
vector21:
  pushl $0
80106068:	6a 00                	push   $0x0
  pushl $21
8010606a:	6a 15                	push   $0x15
  jmp alltraps
8010606c:	e9 96 fa ff ff       	jmp    80105b07 <alltraps>

80106071 <vector22>:
.globl vector22
vector22:
  pushl $0
80106071:	6a 00                	push   $0x0
  pushl $22
80106073:	6a 16                	push   $0x16
  jmp alltraps
80106075:	e9 8d fa ff ff       	jmp    80105b07 <alltraps>

8010607a <vector23>:
.globl vector23
vector23:
  pushl $0
8010607a:	6a 00                	push   $0x0
  pushl $23
8010607c:	6a 17                	push   $0x17
  jmp alltraps
8010607e:	e9 84 fa ff ff       	jmp    80105b07 <alltraps>

80106083 <vector24>:
.globl vector24
vector24:
  pushl $0
80106083:	6a 00                	push   $0x0
  pushl $24
80106085:	6a 18                	push   $0x18
  jmp alltraps
80106087:	e9 7b fa ff ff       	jmp    80105b07 <alltraps>

8010608c <vector25>:
.globl vector25
vector25:
  pushl $0
8010608c:	6a 00                	push   $0x0
  pushl $25
8010608e:	6a 19                	push   $0x19
  jmp alltraps
80106090:	e9 72 fa ff ff       	jmp    80105b07 <alltraps>

80106095 <vector26>:
.globl vector26
vector26:
  pushl $0
80106095:	6a 00                	push   $0x0
  pushl $26
80106097:	6a 1a                	push   $0x1a
  jmp alltraps
80106099:	e9 69 fa ff ff       	jmp    80105b07 <alltraps>

8010609e <vector27>:
.globl vector27
vector27:
  pushl $0
8010609e:	6a 00                	push   $0x0
  pushl $27
801060a0:	6a 1b                	push   $0x1b
  jmp alltraps
801060a2:	e9 60 fa ff ff       	jmp    80105b07 <alltraps>

801060a7 <vector28>:
.globl vector28
vector28:
  pushl $0
801060a7:	6a 00                	push   $0x0
  pushl $28
801060a9:	6a 1c                	push   $0x1c
  jmp alltraps
801060ab:	e9 57 fa ff ff       	jmp    80105b07 <alltraps>

801060b0 <vector29>:
.globl vector29
vector29:
  pushl $0
801060b0:	6a 00                	push   $0x0
  pushl $29
801060b2:	6a 1d                	push   $0x1d
  jmp alltraps
801060b4:	e9 4e fa ff ff       	jmp    80105b07 <alltraps>

801060b9 <vector30>:
.globl vector30
vector30:
  pushl $0
801060b9:	6a 00                	push   $0x0
  pushl $30
801060bb:	6a 1e                	push   $0x1e
  jmp alltraps
801060bd:	e9 45 fa ff ff       	jmp    80105b07 <alltraps>

801060c2 <vector31>:
.globl vector31
vector31:
  pushl $0
801060c2:	6a 00                	push   $0x0
  pushl $31
801060c4:	6a 1f                	push   $0x1f
  jmp alltraps
801060c6:	e9 3c fa ff ff       	jmp    80105b07 <alltraps>

801060cb <vector32>:
.globl vector32
vector32:
  pushl $0
801060cb:	6a 00                	push   $0x0
  pushl $32
801060cd:	6a 20                	push   $0x20
  jmp alltraps
801060cf:	e9 33 fa ff ff       	jmp    80105b07 <alltraps>

801060d4 <vector33>:
.globl vector33
vector33:
  pushl $0
801060d4:	6a 00                	push   $0x0
  pushl $33
801060d6:	6a 21                	push   $0x21
  jmp alltraps
801060d8:	e9 2a fa ff ff       	jmp    80105b07 <alltraps>

801060dd <vector34>:
.globl vector34
vector34:
  pushl $0
801060dd:	6a 00                	push   $0x0
  pushl $34
801060df:	6a 22                	push   $0x22
  jmp alltraps
801060e1:	e9 21 fa ff ff       	jmp    80105b07 <alltraps>

801060e6 <vector35>:
.globl vector35
vector35:
  pushl $0
801060e6:	6a 00                	push   $0x0
  pushl $35
801060e8:	6a 23                	push   $0x23
  jmp alltraps
801060ea:	e9 18 fa ff ff       	jmp    80105b07 <alltraps>

801060ef <vector36>:
.globl vector36
vector36:
  pushl $0
801060ef:	6a 00                	push   $0x0
  pushl $36
801060f1:	6a 24                	push   $0x24
  jmp alltraps
801060f3:	e9 0f fa ff ff       	jmp    80105b07 <alltraps>

801060f8 <vector37>:
.globl vector37
vector37:
  pushl $0
801060f8:	6a 00                	push   $0x0
  pushl $37
801060fa:	6a 25                	push   $0x25
  jmp alltraps
801060fc:	e9 06 fa ff ff       	jmp    80105b07 <alltraps>

80106101 <vector38>:
.globl vector38
vector38:
  pushl $0
80106101:	6a 00                	push   $0x0
  pushl $38
80106103:	6a 26                	push   $0x26
  jmp alltraps
80106105:	e9 fd f9 ff ff       	jmp    80105b07 <alltraps>

8010610a <vector39>:
.globl vector39
vector39:
  pushl $0
8010610a:	6a 00                	push   $0x0
  pushl $39
8010610c:	6a 27                	push   $0x27
  jmp alltraps
8010610e:	e9 f4 f9 ff ff       	jmp    80105b07 <alltraps>

80106113 <vector40>:
.globl vector40
vector40:
  pushl $0
80106113:	6a 00                	push   $0x0
  pushl $40
80106115:	6a 28                	push   $0x28
  jmp alltraps
80106117:	e9 eb f9 ff ff       	jmp    80105b07 <alltraps>

8010611c <vector41>:
.globl vector41
vector41:
  pushl $0
8010611c:	6a 00                	push   $0x0
  pushl $41
8010611e:	6a 29                	push   $0x29
  jmp alltraps
80106120:	e9 e2 f9 ff ff       	jmp    80105b07 <alltraps>

80106125 <vector42>:
.globl vector42
vector42:
  pushl $0
80106125:	6a 00                	push   $0x0
  pushl $42
80106127:	6a 2a                	push   $0x2a
  jmp alltraps
80106129:	e9 d9 f9 ff ff       	jmp    80105b07 <alltraps>

8010612e <vector43>:
.globl vector43
vector43:
  pushl $0
8010612e:	6a 00                	push   $0x0
  pushl $43
80106130:	6a 2b                	push   $0x2b
  jmp alltraps
80106132:	e9 d0 f9 ff ff       	jmp    80105b07 <alltraps>

80106137 <vector44>:
.globl vector44
vector44:
  pushl $0
80106137:	6a 00                	push   $0x0
  pushl $44
80106139:	6a 2c                	push   $0x2c
  jmp alltraps
8010613b:	e9 c7 f9 ff ff       	jmp    80105b07 <alltraps>

80106140 <vector45>:
.globl vector45
vector45:
  pushl $0
80106140:	6a 00                	push   $0x0
  pushl $45
80106142:	6a 2d                	push   $0x2d
  jmp alltraps
80106144:	e9 be f9 ff ff       	jmp    80105b07 <alltraps>

80106149 <vector46>:
.globl vector46
vector46:
  pushl $0
80106149:	6a 00                	push   $0x0
  pushl $46
8010614b:	6a 2e                	push   $0x2e
  jmp alltraps
8010614d:	e9 b5 f9 ff ff       	jmp    80105b07 <alltraps>

80106152 <vector47>:
.globl vector47
vector47:
  pushl $0
80106152:	6a 00                	push   $0x0
  pushl $47
80106154:	6a 2f                	push   $0x2f
  jmp alltraps
80106156:	e9 ac f9 ff ff       	jmp    80105b07 <alltraps>

8010615b <vector48>:
.globl vector48
vector48:
  pushl $0
8010615b:	6a 00                	push   $0x0
  pushl $48
8010615d:	6a 30                	push   $0x30
  jmp alltraps
8010615f:	e9 a3 f9 ff ff       	jmp    80105b07 <alltraps>

80106164 <vector49>:
.globl vector49
vector49:
  pushl $0
80106164:	6a 00                	push   $0x0
  pushl $49
80106166:	6a 31                	push   $0x31
  jmp alltraps
80106168:	e9 9a f9 ff ff       	jmp    80105b07 <alltraps>

8010616d <vector50>:
.globl vector50
vector50:
  pushl $0
8010616d:	6a 00                	push   $0x0
  pushl $50
8010616f:	6a 32                	push   $0x32
  jmp alltraps
80106171:	e9 91 f9 ff ff       	jmp    80105b07 <alltraps>

80106176 <vector51>:
.globl vector51
vector51:
  pushl $0
80106176:	6a 00                	push   $0x0
  pushl $51
80106178:	6a 33                	push   $0x33
  jmp alltraps
8010617a:	e9 88 f9 ff ff       	jmp    80105b07 <alltraps>

8010617f <vector52>:
.globl vector52
vector52:
  pushl $0
8010617f:	6a 00                	push   $0x0
  pushl $52
80106181:	6a 34                	push   $0x34
  jmp alltraps
80106183:	e9 7f f9 ff ff       	jmp    80105b07 <alltraps>

80106188 <vector53>:
.globl vector53
vector53:
  pushl $0
80106188:	6a 00                	push   $0x0
  pushl $53
8010618a:	6a 35                	push   $0x35
  jmp alltraps
8010618c:	e9 76 f9 ff ff       	jmp    80105b07 <alltraps>

80106191 <vector54>:
.globl vector54
vector54:
  pushl $0
80106191:	6a 00                	push   $0x0
  pushl $54
80106193:	6a 36                	push   $0x36
  jmp alltraps
80106195:	e9 6d f9 ff ff       	jmp    80105b07 <alltraps>

8010619a <vector55>:
.globl vector55
vector55:
  pushl $0
8010619a:	6a 00                	push   $0x0
  pushl $55
8010619c:	6a 37                	push   $0x37
  jmp alltraps
8010619e:	e9 64 f9 ff ff       	jmp    80105b07 <alltraps>

801061a3 <vector56>:
.globl vector56
vector56:
  pushl $0
801061a3:	6a 00                	push   $0x0
  pushl $56
801061a5:	6a 38                	push   $0x38
  jmp alltraps
801061a7:	e9 5b f9 ff ff       	jmp    80105b07 <alltraps>

801061ac <vector57>:
.globl vector57
vector57:
  pushl $0
801061ac:	6a 00                	push   $0x0
  pushl $57
801061ae:	6a 39                	push   $0x39
  jmp alltraps
801061b0:	e9 52 f9 ff ff       	jmp    80105b07 <alltraps>

801061b5 <vector58>:
.globl vector58
vector58:
  pushl $0
801061b5:	6a 00                	push   $0x0
  pushl $58
801061b7:	6a 3a                	push   $0x3a
  jmp alltraps
801061b9:	e9 49 f9 ff ff       	jmp    80105b07 <alltraps>

801061be <vector59>:
.globl vector59
vector59:
  pushl $0
801061be:	6a 00                	push   $0x0
  pushl $59
801061c0:	6a 3b                	push   $0x3b
  jmp alltraps
801061c2:	e9 40 f9 ff ff       	jmp    80105b07 <alltraps>

801061c7 <vector60>:
.globl vector60
vector60:
  pushl $0
801061c7:	6a 00                	push   $0x0
  pushl $60
801061c9:	6a 3c                	push   $0x3c
  jmp alltraps
801061cb:	e9 37 f9 ff ff       	jmp    80105b07 <alltraps>

801061d0 <vector61>:
.globl vector61
vector61:
  pushl $0
801061d0:	6a 00                	push   $0x0
  pushl $61
801061d2:	6a 3d                	push   $0x3d
  jmp alltraps
801061d4:	e9 2e f9 ff ff       	jmp    80105b07 <alltraps>

801061d9 <vector62>:
.globl vector62
vector62:
  pushl $0
801061d9:	6a 00                	push   $0x0
  pushl $62
801061db:	6a 3e                	push   $0x3e
  jmp alltraps
801061dd:	e9 25 f9 ff ff       	jmp    80105b07 <alltraps>

801061e2 <vector63>:
.globl vector63
vector63:
  pushl $0
801061e2:	6a 00                	push   $0x0
  pushl $63
801061e4:	6a 3f                	push   $0x3f
  jmp alltraps
801061e6:	e9 1c f9 ff ff       	jmp    80105b07 <alltraps>

801061eb <vector64>:
.globl vector64
vector64:
  pushl $0
801061eb:	6a 00                	push   $0x0
  pushl $64
801061ed:	6a 40                	push   $0x40
  jmp alltraps
801061ef:	e9 13 f9 ff ff       	jmp    80105b07 <alltraps>

801061f4 <vector65>:
.globl vector65
vector65:
  pushl $0
801061f4:	6a 00                	push   $0x0
  pushl $65
801061f6:	6a 41                	push   $0x41
  jmp alltraps
801061f8:	e9 0a f9 ff ff       	jmp    80105b07 <alltraps>

801061fd <vector66>:
.globl vector66
vector66:
  pushl $0
801061fd:	6a 00                	push   $0x0
  pushl $66
801061ff:	6a 42                	push   $0x42
  jmp alltraps
80106201:	e9 01 f9 ff ff       	jmp    80105b07 <alltraps>

80106206 <vector67>:
.globl vector67
vector67:
  pushl $0
80106206:	6a 00                	push   $0x0
  pushl $67
80106208:	6a 43                	push   $0x43
  jmp alltraps
8010620a:	e9 f8 f8 ff ff       	jmp    80105b07 <alltraps>

8010620f <vector68>:
.globl vector68
vector68:
  pushl $0
8010620f:	6a 00                	push   $0x0
  pushl $68
80106211:	6a 44                	push   $0x44
  jmp alltraps
80106213:	e9 ef f8 ff ff       	jmp    80105b07 <alltraps>

80106218 <vector69>:
.globl vector69
vector69:
  pushl $0
80106218:	6a 00                	push   $0x0
  pushl $69
8010621a:	6a 45                	push   $0x45
  jmp alltraps
8010621c:	e9 e6 f8 ff ff       	jmp    80105b07 <alltraps>

80106221 <vector70>:
.globl vector70
vector70:
  pushl $0
80106221:	6a 00                	push   $0x0
  pushl $70
80106223:	6a 46                	push   $0x46
  jmp alltraps
80106225:	e9 dd f8 ff ff       	jmp    80105b07 <alltraps>

8010622a <vector71>:
.globl vector71
vector71:
  pushl $0
8010622a:	6a 00                	push   $0x0
  pushl $71
8010622c:	6a 47                	push   $0x47
  jmp alltraps
8010622e:	e9 d4 f8 ff ff       	jmp    80105b07 <alltraps>

80106233 <vector72>:
.globl vector72
vector72:
  pushl $0
80106233:	6a 00                	push   $0x0
  pushl $72
80106235:	6a 48                	push   $0x48
  jmp alltraps
80106237:	e9 cb f8 ff ff       	jmp    80105b07 <alltraps>

8010623c <vector73>:
.globl vector73
vector73:
  pushl $0
8010623c:	6a 00                	push   $0x0
  pushl $73
8010623e:	6a 49                	push   $0x49
  jmp alltraps
80106240:	e9 c2 f8 ff ff       	jmp    80105b07 <alltraps>

80106245 <vector74>:
.globl vector74
vector74:
  pushl $0
80106245:	6a 00                	push   $0x0
  pushl $74
80106247:	6a 4a                	push   $0x4a
  jmp alltraps
80106249:	e9 b9 f8 ff ff       	jmp    80105b07 <alltraps>

8010624e <vector75>:
.globl vector75
vector75:
  pushl $0
8010624e:	6a 00                	push   $0x0
  pushl $75
80106250:	6a 4b                	push   $0x4b
  jmp alltraps
80106252:	e9 b0 f8 ff ff       	jmp    80105b07 <alltraps>

80106257 <vector76>:
.globl vector76
vector76:
  pushl $0
80106257:	6a 00                	push   $0x0
  pushl $76
80106259:	6a 4c                	push   $0x4c
  jmp alltraps
8010625b:	e9 a7 f8 ff ff       	jmp    80105b07 <alltraps>

80106260 <vector77>:
.globl vector77
vector77:
  pushl $0
80106260:	6a 00                	push   $0x0
  pushl $77
80106262:	6a 4d                	push   $0x4d
  jmp alltraps
80106264:	e9 9e f8 ff ff       	jmp    80105b07 <alltraps>

80106269 <vector78>:
.globl vector78
vector78:
  pushl $0
80106269:	6a 00                	push   $0x0
  pushl $78
8010626b:	6a 4e                	push   $0x4e
  jmp alltraps
8010626d:	e9 95 f8 ff ff       	jmp    80105b07 <alltraps>

80106272 <vector79>:
.globl vector79
vector79:
  pushl $0
80106272:	6a 00                	push   $0x0
  pushl $79
80106274:	6a 4f                	push   $0x4f
  jmp alltraps
80106276:	e9 8c f8 ff ff       	jmp    80105b07 <alltraps>

8010627b <vector80>:
.globl vector80
vector80:
  pushl $0
8010627b:	6a 00                	push   $0x0
  pushl $80
8010627d:	6a 50                	push   $0x50
  jmp alltraps
8010627f:	e9 83 f8 ff ff       	jmp    80105b07 <alltraps>

80106284 <vector81>:
.globl vector81
vector81:
  pushl $0
80106284:	6a 00                	push   $0x0
  pushl $81
80106286:	6a 51                	push   $0x51
  jmp alltraps
80106288:	e9 7a f8 ff ff       	jmp    80105b07 <alltraps>

8010628d <vector82>:
.globl vector82
vector82:
  pushl $0
8010628d:	6a 00                	push   $0x0
  pushl $82
8010628f:	6a 52                	push   $0x52
  jmp alltraps
80106291:	e9 71 f8 ff ff       	jmp    80105b07 <alltraps>

80106296 <vector83>:
.globl vector83
vector83:
  pushl $0
80106296:	6a 00                	push   $0x0
  pushl $83
80106298:	6a 53                	push   $0x53
  jmp alltraps
8010629a:	e9 68 f8 ff ff       	jmp    80105b07 <alltraps>

8010629f <vector84>:
.globl vector84
vector84:
  pushl $0
8010629f:	6a 00                	push   $0x0
  pushl $84
801062a1:	6a 54                	push   $0x54
  jmp alltraps
801062a3:	e9 5f f8 ff ff       	jmp    80105b07 <alltraps>

801062a8 <vector85>:
.globl vector85
vector85:
  pushl $0
801062a8:	6a 00                	push   $0x0
  pushl $85
801062aa:	6a 55                	push   $0x55
  jmp alltraps
801062ac:	e9 56 f8 ff ff       	jmp    80105b07 <alltraps>

801062b1 <vector86>:
.globl vector86
vector86:
  pushl $0
801062b1:	6a 00                	push   $0x0
  pushl $86
801062b3:	6a 56                	push   $0x56
  jmp alltraps
801062b5:	e9 4d f8 ff ff       	jmp    80105b07 <alltraps>

801062ba <vector87>:
.globl vector87
vector87:
  pushl $0
801062ba:	6a 00                	push   $0x0
  pushl $87
801062bc:	6a 57                	push   $0x57
  jmp alltraps
801062be:	e9 44 f8 ff ff       	jmp    80105b07 <alltraps>

801062c3 <vector88>:
.globl vector88
vector88:
  pushl $0
801062c3:	6a 00                	push   $0x0
  pushl $88
801062c5:	6a 58                	push   $0x58
  jmp alltraps
801062c7:	e9 3b f8 ff ff       	jmp    80105b07 <alltraps>

801062cc <vector89>:
.globl vector89
vector89:
  pushl $0
801062cc:	6a 00                	push   $0x0
  pushl $89
801062ce:	6a 59                	push   $0x59
  jmp alltraps
801062d0:	e9 32 f8 ff ff       	jmp    80105b07 <alltraps>

801062d5 <vector90>:
.globl vector90
vector90:
  pushl $0
801062d5:	6a 00                	push   $0x0
  pushl $90
801062d7:	6a 5a                	push   $0x5a
  jmp alltraps
801062d9:	e9 29 f8 ff ff       	jmp    80105b07 <alltraps>

801062de <vector91>:
.globl vector91
vector91:
  pushl $0
801062de:	6a 00                	push   $0x0
  pushl $91
801062e0:	6a 5b                	push   $0x5b
  jmp alltraps
801062e2:	e9 20 f8 ff ff       	jmp    80105b07 <alltraps>

801062e7 <vector92>:
.globl vector92
vector92:
  pushl $0
801062e7:	6a 00                	push   $0x0
  pushl $92
801062e9:	6a 5c                	push   $0x5c
  jmp alltraps
801062eb:	e9 17 f8 ff ff       	jmp    80105b07 <alltraps>

801062f0 <vector93>:
.globl vector93
vector93:
  pushl $0
801062f0:	6a 00                	push   $0x0
  pushl $93
801062f2:	6a 5d                	push   $0x5d
  jmp alltraps
801062f4:	e9 0e f8 ff ff       	jmp    80105b07 <alltraps>

801062f9 <vector94>:
.globl vector94
vector94:
  pushl $0
801062f9:	6a 00                	push   $0x0
  pushl $94
801062fb:	6a 5e                	push   $0x5e
  jmp alltraps
801062fd:	e9 05 f8 ff ff       	jmp    80105b07 <alltraps>

80106302 <vector95>:
.globl vector95
vector95:
  pushl $0
80106302:	6a 00                	push   $0x0
  pushl $95
80106304:	6a 5f                	push   $0x5f
  jmp alltraps
80106306:	e9 fc f7 ff ff       	jmp    80105b07 <alltraps>

8010630b <vector96>:
.globl vector96
vector96:
  pushl $0
8010630b:	6a 00                	push   $0x0
  pushl $96
8010630d:	6a 60                	push   $0x60
  jmp alltraps
8010630f:	e9 f3 f7 ff ff       	jmp    80105b07 <alltraps>

80106314 <vector97>:
.globl vector97
vector97:
  pushl $0
80106314:	6a 00                	push   $0x0
  pushl $97
80106316:	6a 61                	push   $0x61
  jmp alltraps
80106318:	e9 ea f7 ff ff       	jmp    80105b07 <alltraps>

8010631d <vector98>:
.globl vector98
vector98:
  pushl $0
8010631d:	6a 00                	push   $0x0
  pushl $98
8010631f:	6a 62                	push   $0x62
  jmp alltraps
80106321:	e9 e1 f7 ff ff       	jmp    80105b07 <alltraps>

80106326 <vector99>:
.globl vector99
vector99:
  pushl $0
80106326:	6a 00                	push   $0x0
  pushl $99
80106328:	6a 63                	push   $0x63
  jmp alltraps
8010632a:	e9 d8 f7 ff ff       	jmp    80105b07 <alltraps>

8010632f <vector100>:
.globl vector100
vector100:
  pushl $0
8010632f:	6a 00                	push   $0x0
  pushl $100
80106331:	6a 64                	push   $0x64
  jmp alltraps
80106333:	e9 cf f7 ff ff       	jmp    80105b07 <alltraps>

80106338 <vector101>:
.globl vector101
vector101:
  pushl $0
80106338:	6a 00                	push   $0x0
  pushl $101
8010633a:	6a 65                	push   $0x65
  jmp alltraps
8010633c:	e9 c6 f7 ff ff       	jmp    80105b07 <alltraps>

80106341 <vector102>:
.globl vector102
vector102:
  pushl $0
80106341:	6a 00                	push   $0x0
  pushl $102
80106343:	6a 66                	push   $0x66
  jmp alltraps
80106345:	e9 bd f7 ff ff       	jmp    80105b07 <alltraps>

8010634a <vector103>:
.globl vector103
vector103:
  pushl $0
8010634a:	6a 00                	push   $0x0
  pushl $103
8010634c:	6a 67                	push   $0x67
  jmp alltraps
8010634e:	e9 b4 f7 ff ff       	jmp    80105b07 <alltraps>

80106353 <vector104>:
.globl vector104
vector104:
  pushl $0
80106353:	6a 00                	push   $0x0
  pushl $104
80106355:	6a 68                	push   $0x68
  jmp alltraps
80106357:	e9 ab f7 ff ff       	jmp    80105b07 <alltraps>

8010635c <vector105>:
.globl vector105
vector105:
  pushl $0
8010635c:	6a 00                	push   $0x0
  pushl $105
8010635e:	6a 69                	push   $0x69
  jmp alltraps
80106360:	e9 a2 f7 ff ff       	jmp    80105b07 <alltraps>

80106365 <vector106>:
.globl vector106
vector106:
  pushl $0
80106365:	6a 00                	push   $0x0
  pushl $106
80106367:	6a 6a                	push   $0x6a
  jmp alltraps
80106369:	e9 99 f7 ff ff       	jmp    80105b07 <alltraps>

8010636e <vector107>:
.globl vector107
vector107:
  pushl $0
8010636e:	6a 00                	push   $0x0
  pushl $107
80106370:	6a 6b                	push   $0x6b
  jmp alltraps
80106372:	e9 90 f7 ff ff       	jmp    80105b07 <alltraps>

80106377 <vector108>:
.globl vector108
vector108:
  pushl $0
80106377:	6a 00                	push   $0x0
  pushl $108
80106379:	6a 6c                	push   $0x6c
  jmp alltraps
8010637b:	e9 87 f7 ff ff       	jmp    80105b07 <alltraps>

80106380 <vector109>:
.globl vector109
vector109:
  pushl $0
80106380:	6a 00                	push   $0x0
  pushl $109
80106382:	6a 6d                	push   $0x6d
  jmp alltraps
80106384:	e9 7e f7 ff ff       	jmp    80105b07 <alltraps>

80106389 <vector110>:
.globl vector110
vector110:
  pushl $0
80106389:	6a 00                	push   $0x0
  pushl $110
8010638b:	6a 6e                	push   $0x6e
  jmp alltraps
8010638d:	e9 75 f7 ff ff       	jmp    80105b07 <alltraps>

80106392 <vector111>:
.globl vector111
vector111:
  pushl $0
80106392:	6a 00                	push   $0x0
  pushl $111
80106394:	6a 6f                	push   $0x6f
  jmp alltraps
80106396:	e9 6c f7 ff ff       	jmp    80105b07 <alltraps>

8010639b <vector112>:
.globl vector112
vector112:
  pushl $0
8010639b:	6a 00                	push   $0x0
  pushl $112
8010639d:	6a 70                	push   $0x70
  jmp alltraps
8010639f:	e9 63 f7 ff ff       	jmp    80105b07 <alltraps>

801063a4 <vector113>:
.globl vector113
vector113:
  pushl $0
801063a4:	6a 00                	push   $0x0
  pushl $113
801063a6:	6a 71                	push   $0x71
  jmp alltraps
801063a8:	e9 5a f7 ff ff       	jmp    80105b07 <alltraps>

801063ad <vector114>:
.globl vector114
vector114:
  pushl $0
801063ad:	6a 00                	push   $0x0
  pushl $114
801063af:	6a 72                	push   $0x72
  jmp alltraps
801063b1:	e9 51 f7 ff ff       	jmp    80105b07 <alltraps>

801063b6 <vector115>:
.globl vector115
vector115:
  pushl $0
801063b6:	6a 00                	push   $0x0
  pushl $115
801063b8:	6a 73                	push   $0x73
  jmp alltraps
801063ba:	e9 48 f7 ff ff       	jmp    80105b07 <alltraps>

801063bf <vector116>:
.globl vector116
vector116:
  pushl $0
801063bf:	6a 00                	push   $0x0
  pushl $116
801063c1:	6a 74                	push   $0x74
  jmp alltraps
801063c3:	e9 3f f7 ff ff       	jmp    80105b07 <alltraps>

801063c8 <vector117>:
.globl vector117
vector117:
  pushl $0
801063c8:	6a 00                	push   $0x0
  pushl $117
801063ca:	6a 75                	push   $0x75
  jmp alltraps
801063cc:	e9 36 f7 ff ff       	jmp    80105b07 <alltraps>

801063d1 <vector118>:
.globl vector118
vector118:
  pushl $0
801063d1:	6a 00                	push   $0x0
  pushl $118
801063d3:	6a 76                	push   $0x76
  jmp alltraps
801063d5:	e9 2d f7 ff ff       	jmp    80105b07 <alltraps>

801063da <vector119>:
.globl vector119
vector119:
  pushl $0
801063da:	6a 00                	push   $0x0
  pushl $119
801063dc:	6a 77                	push   $0x77
  jmp alltraps
801063de:	e9 24 f7 ff ff       	jmp    80105b07 <alltraps>

801063e3 <vector120>:
.globl vector120
vector120:
  pushl $0
801063e3:	6a 00                	push   $0x0
  pushl $120
801063e5:	6a 78                	push   $0x78
  jmp alltraps
801063e7:	e9 1b f7 ff ff       	jmp    80105b07 <alltraps>

801063ec <vector121>:
.globl vector121
vector121:
  pushl $0
801063ec:	6a 00                	push   $0x0
  pushl $121
801063ee:	6a 79                	push   $0x79
  jmp alltraps
801063f0:	e9 12 f7 ff ff       	jmp    80105b07 <alltraps>

801063f5 <vector122>:
.globl vector122
vector122:
  pushl $0
801063f5:	6a 00                	push   $0x0
  pushl $122
801063f7:	6a 7a                	push   $0x7a
  jmp alltraps
801063f9:	e9 09 f7 ff ff       	jmp    80105b07 <alltraps>

801063fe <vector123>:
.globl vector123
vector123:
  pushl $0
801063fe:	6a 00                	push   $0x0
  pushl $123
80106400:	6a 7b                	push   $0x7b
  jmp alltraps
80106402:	e9 00 f7 ff ff       	jmp    80105b07 <alltraps>

80106407 <vector124>:
.globl vector124
vector124:
  pushl $0
80106407:	6a 00                	push   $0x0
  pushl $124
80106409:	6a 7c                	push   $0x7c
  jmp alltraps
8010640b:	e9 f7 f6 ff ff       	jmp    80105b07 <alltraps>

80106410 <vector125>:
.globl vector125
vector125:
  pushl $0
80106410:	6a 00                	push   $0x0
  pushl $125
80106412:	6a 7d                	push   $0x7d
  jmp alltraps
80106414:	e9 ee f6 ff ff       	jmp    80105b07 <alltraps>

80106419 <vector126>:
.globl vector126
vector126:
  pushl $0
80106419:	6a 00                	push   $0x0
  pushl $126
8010641b:	6a 7e                	push   $0x7e
  jmp alltraps
8010641d:	e9 e5 f6 ff ff       	jmp    80105b07 <alltraps>

80106422 <vector127>:
.globl vector127
vector127:
  pushl $0
80106422:	6a 00                	push   $0x0
  pushl $127
80106424:	6a 7f                	push   $0x7f
  jmp alltraps
80106426:	e9 dc f6 ff ff       	jmp    80105b07 <alltraps>

8010642b <vector128>:
.globl vector128
vector128:
  pushl $0
8010642b:	6a 00                	push   $0x0
  pushl $128
8010642d:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80106432:	e9 d0 f6 ff ff       	jmp    80105b07 <alltraps>

80106437 <vector129>:
.globl vector129
vector129:
  pushl $0
80106437:	6a 00                	push   $0x0
  pushl $129
80106439:	68 81 00 00 00       	push   $0x81
  jmp alltraps
8010643e:	e9 c4 f6 ff ff       	jmp    80105b07 <alltraps>

80106443 <vector130>:
.globl vector130
vector130:
  pushl $0
80106443:	6a 00                	push   $0x0
  pushl $130
80106445:	68 82 00 00 00       	push   $0x82
  jmp alltraps
8010644a:	e9 b8 f6 ff ff       	jmp    80105b07 <alltraps>

8010644f <vector131>:
.globl vector131
vector131:
  pushl $0
8010644f:	6a 00                	push   $0x0
  pushl $131
80106451:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106456:	e9 ac f6 ff ff       	jmp    80105b07 <alltraps>

8010645b <vector132>:
.globl vector132
vector132:
  pushl $0
8010645b:	6a 00                	push   $0x0
  pushl $132
8010645d:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80106462:	e9 a0 f6 ff ff       	jmp    80105b07 <alltraps>

80106467 <vector133>:
.globl vector133
vector133:
  pushl $0
80106467:	6a 00                	push   $0x0
  pushl $133
80106469:	68 85 00 00 00       	push   $0x85
  jmp alltraps
8010646e:	e9 94 f6 ff ff       	jmp    80105b07 <alltraps>

80106473 <vector134>:
.globl vector134
vector134:
  pushl $0
80106473:	6a 00                	push   $0x0
  pushl $134
80106475:	68 86 00 00 00       	push   $0x86
  jmp alltraps
8010647a:	e9 88 f6 ff ff       	jmp    80105b07 <alltraps>

8010647f <vector135>:
.globl vector135
vector135:
  pushl $0
8010647f:	6a 00                	push   $0x0
  pushl $135
80106481:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106486:	e9 7c f6 ff ff       	jmp    80105b07 <alltraps>

8010648b <vector136>:
.globl vector136
vector136:
  pushl $0
8010648b:	6a 00                	push   $0x0
  pushl $136
8010648d:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80106492:	e9 70 f6 ff ff       	jmp    80105b07 <alltraps>

80106497 <vector137>:
.globl vector137
vector137:
  pushl $0
80106497:	6a 00                	push   $0x0
  pushl $137
80106499:	68 89 00 00 00       	push   $0x89
  jmp alltraps
8010649e:	e9 64 f6 ff ff       	jmp    80105b07 <alltraps>

801064a3 <vector138>:
.globl vector138
vector138:
  pushl $0
801064a3:	6a 00                	push   $0x0
  pushl $138
801064a5:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
801064aa:	e9 58 f6 ff ff       	jmp    80105b07 <alltraps>

801064af <vector139>:
.globl vector139
vector139:
  pushl $0
801064af:	6a 00                	push   $0x0
  pushl $139
801064b1:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
801064b6:	e9 4c f6 ff ff       	jmp    80105b07 <alltraps>

801064bb <vector140>:
.globl vector140
vector140:
  pushl $0
801064bb:	6a 00                	push   $0x0
  pushl $140
801064bd:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
801064c2:	e9 40 f6 ff ff       	jmp    80105b07 <alltraps>

801064c7 <vector141>:
.globl vector141
vector141:
  pushl $0
801064c7:	6a 00                	push   $0x0
  pushl $141
801064c9:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
801064ce:	e9 34 f6 ff ff       	jmp    80105b07 <alltraps>

801064d3 <vector142>:
.globl vector142
vector142:
  pushl $0
801064d3:	6a 00                	push   $0x0
  pushl $142
801064d5:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
801064da:	e9 28 f6 ff ff       	jmp    80105b07 <alltraps>

801064df <vector143>:
.globl vector143
vector143:
  pushl $0
801064df:	6a 00                	push   $0x0
  pushl $143
801064e1:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
801064e6:	e9 1c f6 ff ff       	jmp    80105b07 <alltraps>

801064eb <vector144>:
.globl vector144
vector144:
  pushl $0
801064eb:	6a 00                	push   $0x0
  pushl $144
801064ed:	68 90 00 00 00       	push   $0x90
  jmp alltraps
801064f2:	e9 10 f6 ff ff       	jmp    80105b07 <alltraps>

801064f7 <vector145>:
.globl vector145
vector145:
  pushl $0
801064f7:	6a 00                	push   $0x0
  pushl $145
801064f9:	68 91 00 00 00       	push   $0x91
  jmp alltraps
801064fe:	e9 04 f6 ff ff       	jmp    80105b07 <alltraps>

80106503 <vector146>:
.globl vector146
vector146:
  pushl $0
80106503:	6a 00                	push   $0x0
  pushl $146
80106505:	68 92 00 00 00       	push   $0x92
  jmp alltraps
8010650a:	e9 f8 f5 ff ff       	jmp    80105b07 <alltraps>

8010650f <vector147>:
.globl vector147
vector147:
  pushl $0
8010650f:	6a 00                	push   $0x0
  pushl $147
80106511:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106516:	e9 ec f5 ff ff       	jmp    80105b07 <alltraps>

8010651b <vector148>:
.globl vector148
vector148:
  pushl $0
8010651b:	6a 00                	push   $0x0
  pushl $148
8010651d:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80106522:	e9 e0 f5 ff ff       	jmp    80105b07 <alltraps>

80106527 <vector149>:
.globl vector149
vector149:
  pushl $0
80106527:	6a 00                	push   $0x0
  pushl $149
80106529:	68 95 00 00 00       	push   $0x95
  jmp alltraps
8010652e:	e9 d4 f5 ff ff       	jmp    80105b07 <alltraps>

80106533 <vector150>:
.globl vector150
vector150:
  pushl $0
80106533:	6a 00                	push   $0x0
  pushl $150
80106535:	68 96 00 00 00       	push   $0x96
  jmp alltraps
8010653a:	e9 c8 f5 ff ff       	jmp    80105b07 <alltraps>

8010653f <vector151>:
.globl vector151
vector151:
  pushl $0
8010653f:	6a 00                	push   $0x0
  pushl $151
80106541:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106546:	e9 bc f5 ff ff       	jmp    80105b07 <alltraps>

8010654b <vector152>:
.globl vector152
vector152:
  pushl $0
8010654b:	6a 00                	push   $0x0
  pushl $152
8010654d:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80106552:	e9 b0 f5 ff ff       	jmp    80105b07 <alltraps>

80106557 <vector153>:
.globl vector153
vector153:
  pushl $0
80106557:	6a 00                	push   $0x0
  pushl $153
80106559:	68 99 00 00 00       	push   $0x99
  jmp alltraps
8010655e:	e9 a4 f5 ff ff       	jmp    80105b07 <alltraps>

80106563 <vector154>:
.globl vector154
vector154:
  pushl $0
80106563:	6a 00                	push   $0x0
  pushl $154
80106565:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
8010656a:	e9 98 f5 ff ff       	jmp    80105b07 <alltraps>

8010656f <vector155>:
.globl vector155
vector155:
  pushl $0
8010656f:	6a 00                	push   $0x0
  pushl $155
80106571:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106576:	e9 8c f5 ff ff       	jmp    80105b07 <alltraps>

8010657b <vector156>:
.globl vector156
vector156:
  pushl $0
8010657b:	6a 00                	push   $0x0
  pushl $156
8010657d:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80106582:	e9 80 f5 ff ff       	jmp    80105b07 <alltraps>

80106587 <vector157>:
.globl vector157
vector157:
  pushl $0
80106587:	6a 00                	push   $0x0
  pushl $157
80106589:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
8010658e:	e9 74 f5 ff ff       	jmp    80105b07 <alltraps>

80106593 <vector158>:
.globl vector158
vector158:
  pushl $0
80106593:	6a 00                	push   $0x0
  pushl $158
80106595:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
8010659a:	e9 68 f5 ff ff       	jmp    80105b07 <alltraps>

8010659f <vector159>:
.globl vector159
vector159:
  pushl $0
8010659f:	6a 00                	push   $0x0
  pushl $159
801065a1:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
801065a6:	e9 5c f5 ff ff       	jmp    80105b07 <alltraps>

801065ab <vector160>:
.globl vector160
vector160:
  pushl $0
801065ab:	6a 00                	push   $0x0
  pushl $160
801065ad:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
801065b2:	e9 50 f5 ff ff       	jmp    80105b07 <alltraps>

801065b7 <vector161>:
.globl vector161
vector161:
  pushl $0
801065b7:	6a 00                	push   $0x0
  pushl $161
801065b9:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
801065be:	e9 44 f5 ff ff       	jmp    80105b07 <alltraps>

801065c3 <vector162>:
.globl vector162
vector162:
  pushl $0
801065c3:	6a 00                	push   $0x0
  pushl $162
801065c5:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
801065ca:	e9 38 f5 ff ff       	jmp    80105b07 <alltraps>

801065cf <vector163>:
.globl vector163
vector163:
  pushl $0
801065cf:	6a 00                	push   $0x0
  pushl $163
801065d1:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
801065d6:	e9 2c f5 ff ff       	jmp    80105b07 <alltraps>

801065db <vector164>:
.globl vector164
vector164:
  pushl $0
801065db:	6a 00                	push   $0x0
  pushl $164
801065dd:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
801065e2:	e9 20 f5 ff ff       	jmp    80105b07 <alltraps>

801065e7 <vector165>:
.globl vector165
vector165:
  pushl $0
801065e7:	6a 00                	push   $0x0
  pushl $165
801065e9:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
801065ee:	e9 14 f5 ff ff       	jmp    80105b07 <alltraps>

801065f3 <vector166>:
.globl vector166
vector166:
  pushl $0
801065f3:	6a 00                	push   $0x0
  pushl $166
801065f5:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
801065fa:	e9 08 f5 ff ff       	jmp    80105b07 <alltraps>

801065ff <vector167>:
.globl vector167
vector167:
  pushl $0
801065ff:	6a 00                	push   $0x0
  pushl $167
80106601:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106606:	e9 fc f4 ff ff       	jmp    80105b07 <alltraps>

8010660b <vector168>:
.globl vector168
vector168:
  pushl $0
8010660b:	6a 00                	push   $0x0
  pushl $168
8010660d:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80106612:	e9 f0 f4 ff ff       	jmp    80105b07 <alltraps>

80106617 <vector169>:
.globl vector169
vector169:
  pushl $0
80106617:	6a 00                	push   $0x0
  pushl $169
80106619:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
8010661e:	e9 e4 f4 ff ff       	jmp    80105b07 <alltraps>

80106623 <vector170>:
.globl vector170
vector170:
  pushl $0
80106623:	6a 00                	push   $0x0
  pushl $170
80106625:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
8010662a:	e9 d8 f4 ff ff       	jmp    80105b07 <alltraps>

8010662f <vector171>:
.globl vector171
vector171:
  pushl $0
8010662f:	6a 00                	push   $0x0
  pushl $171
80106631:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106636:	e9 cc f4 ff ff       	jmp    80105b07 <alltraps>

8010663b <vector172>:
.globl vector172
vector172:
  pushl $0
8010663b:	6a 00                	push   $0x0
  pushl $172
8010663d:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80106642:	e9 c0 f4 ff ff       	jmp    80105b07 <alltraps>

80106647 <vector173>:
.globl vector173
vector173:
  pushl $0
80106647:	6a 00                	push   $0x0
  pushl $173
80106649:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
8010664e:	e9 b4 f4 ff ff       	jmp    80105b07 <alltraps>

80106653 <vector174>:
.globl vector174
vector174:
  pushl $0
80106653:	6a 00                	push   $0x0
  pushl $174
80106655:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
8010665a:	e9 a8 f4 ff ff       	jmp    80105b07 <alltraps>

8010665f <vector175>:
.globl vector175
vector175:
  pushl $0
8010665f:	6a 00                	push   $0x0
  pushl $175
80106661:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106666:	e9 9c f4 ff ff       	jmp    80105b07 <alltraps>

8010666b <vector176>:
.globl vector176
vector176:
  pushl $0
8010666b:	6a 00                	push   $0x0
  pushl $176
8010666d:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80106672:	e9 90 f4 ff ff       	jmp    80105b07 <alltraps>

80106677 <vector177>:
.globl vector177
vector177:
  pushl $0
80106677:	6a 00                	push   $0x0
  pushl $177
80106679:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
8010667e:	e9 84 f4 ff ff       	jmp    80105b07 <alltraps>

80106683 <vector178>:
.globl vector178
vector178:
  pushl $0
80106683:	6a 00                	push   $0x0
  pushl $178
80106685:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
8010668a:	e9 78 f4 ff ff       	jmp    80105b07 <alltraps>

8010668f <vector179>:
.globl vector179
vector179:
  pushl $0
8010668f:	6a 00                	push   $0x0
  pushl $179
80106691:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106696:	e9 6c f4 ff ff       	jmp    80105b07 <alltraps>

8010669b <vector180>:
.globl vector180
vector180:
  pushl $0
8010669b:	6a 00                	push   $0x0
  pushl $180
8010669d:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
801066a2:	e9 60 f4 ff ff       	jmp    80105b07 <alltraps>

801066a7 <vector181>:
.globl vector181
vector181:
  pushl $0
801066a7:	6a 00                	push   $0x0
  pushl $181
801066a9:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
801066ae:	e9 54 f4 ff ff       	jmp    80105b07 <alltraps>

801066b3 <vector182>:
.globl vector182
vector182:
  pushl $0
801066b3:	6a 00                	push   $0x0
  pushl $182
801066b5:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
801066ba:	e9 48 f4 ff ff       	jmp    80105b07 <alltraps>

801066bf <vector183>:
.globl vector183
vector183:
  pushl $0
801066bf:	6a 00                	push   $0x0
  pushl $183
801066c1:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
801066c6:	e9 3c f4 ff ff       	jmp    80105b07 <alltraps>

801066cb <vector184>:
.globl vector184
vector184:
  pushl $0
801066cb:	6a 00                	push   $0x0
  pushl $184
801066cd:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
801066d2:	e9 30 f4 ff ff       	jmp    80105b07 <alltraps>

801066d7 <vector185>:
.globl vector185
vector185:
  pushl $0
801066d7:	6a 00                	push   $0x0
  pushl $185
801066d9:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
801066de:	e9 24 f4 ff ff       	jmp    80105b07 <alltraps>

801066e3 <vector186>:
.globl vector186
vector186:
  pushl $0
801066e3:	6a 00                	push   $0x0
  pushl $186
801066e5:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
801066ea:	e9 18 f4 ff ff       	jmp    80105b07 <alltraps>

801066ef <vector187>:
.globl vector187
vector187:
  pushl $0
801066ef:	6a 00                	push   $0x0
  pushl $187
801066f1:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
801066f6:	e9 0c f4 ff ff       	jmp    80105b07 <alltraps>

801066fb <vector188>:
.globl vector188
vector188:
  pushl $0
801066fb:	6a 00                	push   $0x0
  pushl $188
801066fd:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80106702:	e9 00 f4 ff ff       	jmp    80105b07 <alltraps>

80106707 <vector189>:
.globl vector189
vector189:
  pushl $0
80106707:	6a 00                	push   $0x0
  pushl $189
80106709:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
8010670e:	e9 f4 f3 ff ff       	jmp    80105b07 <alltraps>

80106713 <vector190>:
.globl vector190
vector190:
  pushl $0
80106713:	6a 00                	push   $0x0
  pushl $190
80106715:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
8010671a:	e9 e8 f3 ff ff       	jmp    80105b07 <alltraps>

8010671f <vector191>:
.globl vector191
vector191:
  pushl $0
8010671f:	6a 00                	push   $0x0
  pushl $191
80106721:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106726:	e9 dc f3 ff ff       	jmp    80105b07 <alltraps>

8010672b <vector192>:
.globl vector192
vector192:
  pushl $0
8010672b:	6a 00                	push   $0x0
  pushl $192
8010672d:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80106732:	e9 d0 f3 ff ff       	jmp    80105b07 <alltraps>

80106737 <vector193>:
.globl vector193
vector193:
  pushl $0
80106737:	6a 00                	push   $0x0
  pushl $193
80106739:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
8010673e:	e9 c4 f3 ff ff       	jmp    80105b07 <alltraps>

80106743 <vector194>:
.globl vector194
vector194:
  pushl $0
80106743:	6a 00                	push   $0x0
  pushl $194
80106745:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
8010674a:	e9 b8 f3 ff ff       	jmp    80105b07 <alltraps>

8010674f <vector195>:
.globl vector195
vector195:
  pushl $0
8010674f:	6a 00                	push   $0x0
  pushl $195
80106751:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106756:	e9 ac f3 ff ff       	jmp    80105b07 <alltraps>

8010675b <vector196>:
.globl vector196
vector196:
  pushl $0
8010675b:	6a 00                	push   $0x0
  pushl $196
8010675d:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80106762:	e9 a0 f3 ff ff       	jmp    80105b07 <alltraps>

80106767 <vector197>:
.globl vector197
vector197:
  pushl $0
80106767:	6a 00                	push   $0x0
  pushl $197
80106769:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
8010676e:	e9 94 f3 ff ff       	jmp    80105b07 <alltraps>

80106773 <vector198>:
.globl vector198
vector198:
  pushl $0
80106773:	6a 00                	push   $0x0
  pushl $198
80106775:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
8010677a:	e9 88 f3 ff ff       	jmp    80105b07 <alltraps>

8010677f <vector199>:
.globl vector199
vector199:
  pushl $0
8010677f:	6a 00                	push   $0x0
  pushl $199
80106781:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106786:	e9 7c f3 ff ff       	jmp    80105b07 <alltraps>

8010678b <vector200>:
.globl vector200
vector200:
  pushl $0
8010678b:	6a 00                	push   $0x0
  pushl $200
8010678d:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80106792:	e9 70 f3 ff ff       	jmp    80105b07 <alltraps>

80106797 <vector201>:
.globl vector201
vector201:
  pushl $0
80106797:	6a 00                	push   $0x0
  pushl $201
80106799:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
8010679e:	e9 64 f3 ff ff       	jmp    80105b07 <alltraps>

801067a3 <vector202>:
.globl vector202
vector202:
  pushl $0
801067a3:	6a 00                	push   $0x0
  pushl $202
801067a5:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
801067aa:	e9 58 f3 ff ff       	jmp    80105b07 <alltraps>

801067af <vector203>:
.globl vector203
vector203:
  pushl $0
801067af:	6a 00                	push   $0x0
  pushl $203
801067b1:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
801067b6:	e9 4c f3 ff ff       	jmp    80105b07 <alltraps>

801067bb <vector204>:
.globl vector204
vector204:
  pushl $0
801067bb:	6a 00                	push   $0x0
  pushl $204
801067bd:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
801067c2:	e9 40 f3 ff ff       	jmp    80105b07 <alltraps>

801067c7 <vector205>:
.globl vector205
vector205:
  pushl $0
801067c7:	6a 00                	push   $0x0
  pushl $205
801067c9:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
801067ce:	e9 34 f3 ff ff       	jmp    80105b07 <alltraps>

801067d3 <vector206>:
.globl vector206
vector206:
  pushl $0
801067d3:	6a 00                	push   $0x0
  pushl $206
801067d5:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
801067da:	e9 28 f3 ff ff       	jmp    80105b07 <alltraps>

801067df <vector207>:
.globl vector207
vector207:
  pushl $0
801067df:	6a 00                	push   $0x0
  pushl $207
801067e1:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
801067e6:	e9 1c f3 ff ff       	jmp    80105b07 <alltraps>

801067eb <vector208>:
.globl vector208
vector208:
  pushl $0
801067eb:	6a 00                	push   $0x0
  pushl $208
801067ed:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
801067f2:	e9 10 f3 ff ff       	jmp    80105b07 <alltraps>

801067f7 <vector209>:
.globl vector209
vector209:
  pushl $0
801067f7:	6a 00                	push   $0x0
  pushl $209
801067f9:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
801067fe:	e9 04 f3 ff ff       	jmp    80105b07 <alltraps>

80106803 <vector210>:
.globl vector210
vector210:
  pushl $0
80106803:	6a 00                	push   $0x0
  pushl $210
80106805:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
8010680a:	e9 f8 f2 ff ff       	jmp    80105b07 <alltraps>

8010680f <vector211>:
.globl vector211
vector211:
  pushl $0
8010680f:	6a 00                	push   $0x0
  pushl $211
80106811:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106816:	e9 ec f2 ff ff       	jmp    80105b07 <alltraps>

8010681b <vector212>:
.globl vector212
vector212:
  pushl $0
8010681b:	6a 00                	push   $0x0
  pushl $212
8010681d:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80106822:	e9 e0 f2 ff ff       	jmp    80105b07 <alltraps>

80106827 <vector213>:
.globl vector213
vector213:
  pushl $0
80106827:	6a 00                	push   $0x0
  pushl $213
80106829:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
8010682e:	e9 d4 f2 ff ff       	jmp    80105b07 <alltraps>

80106833 <vector214>:
.globl vector214
vector214:
  pushl $0
80106833:	6a 00                	push   $0x0
  pushl $214
80106835:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
8010683a:	e9 c8 f2 ff ff       	jmp    80105b07 <alltraps>

8010683f <vector215>:
.globl vector215
vector215:
  pushl $0
8010683f:	6a 00                	push   $0x0
  pushl $215
80106841:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106846:	e9 bc f2 ff ff       	jmp    80105b07 <alltraps>

8010684b <vector216>:
.globl vector216
vector216:
  pushl $0
8010684b:	6a 00                	push   $0x0
  pushl $216
8010684d:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80106852:	e9 b0 f2 ff ff       	jmp    80105b07 <alltraps>

80106857 <vector217>:
.globl vector217
vector217:
  pushl $0
80106857:	6a 00                	push   $0x0
  pushl $217
80106859:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
8010685e:	e9 a4 f2 ff ff       	jmp    80105b07 <alltraps>

80106863 <vector218>:
.globl vector218
vector218:
  pushl $0
80106863:	6a 00                	push   $0x0
  pushl $218
80106865:	68 da 00 00 00       	push   $0xda
  jmp alltraps
8010686a:	e9 98 f2 ff ff       	jmp    80105b07 <alltraps>

8010686f <vector219>:
.globl vector219
vector219:
  pushl $0
8010686f:	6a 00                	push   $0x0
  pushl $219
80106871:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106876:	e9 8c f2 ff ff       	jmp    80105b07 <alltraps>

8010687b <vector220>:
.globl vector220
vector220:
  pushl $0
8010687b:	6a 00                	push   $0x0
  pushl $220
8010687d:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80106882:	e9 80 f2 ff ff       	jmp    80105b07 <alltraps>

80106887 <vector221>:
.globl vector221
vector221:
  pushl $0
80106887:	6a 00                	push   $0x0
  pushl $221
80106889:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
8010688e:	e9 74 f2 ff ff       	jmp    80105b07 <alltraps>

80106893 <vector222>:
.globl vector222
vector222:
  pushl $0
80106893:	6a 00                	push   $0x0
  pushl $222
80106895:	68 de 00 00 00       	push   $0xde
  jmp alltraps
8010689a:	e9 68 f2 ff ff       	jmp    80105b07 <alltraps>

8010689f <vector223>:
.globl vector223
vector223:
  pushl $0
8010689f:	6a 00                	push   $0x0
  pushl $223
801068a1:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
801068a6:	e9 5c f2 ff ff       	jmp    80105b07 <alltraps>

801068ab <vector224>:
.globl vector224
vector224:
  pushl $0
801068ab:	6a 00                	push   $0x0
  pushl $224
801068ad:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
801068b2:	e9 50 f2 ff ff       	jmp    80105b07 <alltraps>

801068b7 <vector225>:
.globl vector225
vector225:
  pushl $0
801068b7:	6a 00                	push   $0x0
  pushl $225
801068b9:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
801068be:	e9 44 f2 ff ff       	jmp    80105b07 <alltraps>

801068c3 <vector226>:
.globl vector226
vector226:
  pushl $0
801068c3:	6a 00                	push   $0x0
  pushl $226
801068c5:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
801068ca:	e9 38 f2 ff ff       	jmp    80105b07 <alltraps>

801068cf <vector227>:
.globl vector227
vector227:
  pushl $0
801068cf:	6a 00                	push   $0x0
  pushl $227
801068d1:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
801068d6:	e9 2c f2 ff ff       	jmp    80105b07 <alltraps>

801068db <vector228>:
.globl vector228
vector228:
  pushl $0
801068db:	6a 00                	push   $0x0
  pushl $228
801068dd:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
801068e2:	e9 20 f2 ff ff       	jmp    80105b07 <alltraps>

801068e7 <vector229>:
.globl vector229
vector229:
  pushl $0
801068e7:	6a 00                	push   $0x0
  pushl $229
801068e9:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
801068ee:	e9 14 f2 ff ff       	jmp    80105b07 <alltraps>

801068f3 <vector230>:
.globl vector230
vector230:
  pushl $0
801068f3:	6a 00                	push   $0x0
  pushl $230
801068f5:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
801068fa:	e9 08 f2 ff ff       	jmp    80105b07 <alltraps>

801068ff <vector231>:
.globl vector231
vector231:
  pushl $0
801068ff:	6a 00                	push   $0x0
  pushl $231
80106901:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106906:	e9 fc f1 ff ff       	jmp    80105b07 <alltraps>

8010690b <vector232>:
.globl vector232
vector232:
  pushl $0
8010690b:	6a 00                	push   $0x0
  pushl $232
8010690d:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80106912:	e9 f0 f1 ff ff       	jmp    80105b07 <alltraps>

80106917 <vector233>:
.globl vector233
vector233:
  pushl $0
80106917:	6a 00                	push   $0x0
  pushl $233
80106919:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
8010691e:	e9 e4 f1 ff ff       	jmp    80105b07 <alltraps>

80106923 <vector234>:
.globl vector234
vector234:
  pushl $0
80106923:	6a 00                	push   $0x0
  pushl $234
80106925:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
8010692a:	e9 d8 f1 ff ff       	jmp    80105b07 <alltraps>

8010692f <vector235>:
.globl vector235
vector235:
  pushl $0
8010692f:	6a 00                	push   $0x0
  pushl $235
80106931:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106936:	e9 cc f1 ff ff       	jmp    80105b07 <alltraps>

8010693b <vector236>:
.globl vector236
vector236:
  pushl $0
8010693b:	6a 00                	push   $0x0
  pushl $236
8010693d:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80106942:	e9 c0 f1 ff ff       	jmp    80105b07 <alltraps>

80106947 <vector237>:
.globl vector237
vector237:
  pushl $0
80106947:	6a 00                	push   $0x0
  pushl $237
80106949:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
8010694e:	e9 b4 f1 ff ff       	jmp    80105b07 <alltraps>

80106953 <vector238>:
.globl vector238
vector238:
  pushl $0
80106953:	6a 00                	push   $0x0
  pushl $238
80106955:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
8010695a:	e9 a8 f1 ff ff       	jmp    80105b07 <alltraps>

8010695f <vector239>:
.globl vector239
vector239:
  pushl $0
8010695f:	6a 00                	push   $0x0
  pushl $239
80106961:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106966:	e9 9c f1 ff ff       	jmp    80105b07 <alltraps>

8010696b <vector240>:
.globl vector240
vector240:
  pushl $0
8010696b:	6a 00                	push   $0x0
  pushl $240
8010696d:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80106972:	e9 90 f1 ff ff       	jmp    80105b07 <alltraps>

80106977 <vector241>:
.globl vector241
vector241:
  pushl $0
80106977:	6a 00                	push   $0x0
  pushl $241
80106979:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
8010697e:	e9 84 f1 ff ff       	jmp    80105b07 <alltraps>

80106983 <vector242>:
.globl vector242
vector242:
  pushl $0
80106983:	6a 00                	push   $0x0
  pushl $242
80106985:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
8010698a:	e9 78 f1 ff ff       	jmp    80105b07 <alltraps>

8010698f <vector243>:
.globl vector243
vector243:
  pushl $0
8010698f:	6a 00                	push   $0x0
  pushl $243
80106991:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106996:	e9 6c f1 ff ff       	jmp    80105b07 <alltraps>

8010699b <vector244>:
.globl vector244
vector244:
  pushl $0
8010699b:	6a 00                	push   $0x0
  pushl $244
8010699d:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
801069a2:	e9 60 f1 ff ff       	jmp    80105b07 <alltraps>

801069a7 <vector245>:
.globl vector245
vector245:
  pushl $0
801069a7:	6a 00                	push   $0x0
  pushl $245
801069a9:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
801069ae:	e9 54 f1 ff ff       	jmp    80105b07 <alltraps>

801069b3 <vector246>:
.globl vector246
vector246:
  pushl $0
801069b3:	6a 00                	push   $0x0
  pushl $246
801069b5:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
801069ba:	e9 48 f1 ff ff       	jmp    80105b07 <alltraps>

801069bf <vector247>:
.globl vector247
vector247:
  pushl $0
801069bf:	6a 00                	push   $0x0
  pushl $247
801069c1:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
801069c6:	e9 3c f1 ff ff       	jmp    80105b07 <alltraps>

801069cb <vector248>:
.globl vector248
vector248:
  pushl $0
801069cb:	6a 00                	push   $0x0
  pushl $248
801069cd:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
801069d2:	e9 30 f1 ff ff       	jmp    80105b07 <alltraps>

801069d7 <vector249>:
.globl vector249
vector249:
  pushl $0
801069d7:	6a 00                	push   $0x0
  pushl $249
801069d9:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
801069de:	e9 24 f1 ff ff       	jmp    80105b07 <alltraps>

801069e3 <vector250>:
.globl vector250
vector250:
  pushl $0
801069e3:	6a 00                	push   $0x0
  pushl $250
801069e5:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
801069ea:	e9 18 f1 ff ff       	jmp    80105b07 <alltraps>

801069ef <vector251>:
.globl vector251
vector251:
  pushl $0
801069ef:	6a 00                	push   $0x0
  pushl $251
801069f1:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
801069f6:	e9 0c f1 ff ff       	jmp    80105b07 <alltraps>

801069fb <vector252>:
.globl vector252
vector252:
  pushl $0
801069fb:	6a 00                	push   $0x0
  pushl $252
801069fd:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80106a02:	e9 00 f1 ff ff       	jmp    80105b07 <alltraps>

80106a07 <vector253>:
.globl vector253
vector253:
  pushl $0
80106a07:	6a 00                	push   $0x0
  pushl $253
80106a09:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80106a0e:	e9 f4 f0 ff ff       	jmp    80105b07 <alltraps>

80106a13 <vector254>:
.globl vector254
vector254:
  pushl $0
80106a13:	6a 00                	push   $0x0
  pushl $254
80106a15:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106a1a:	e9 e8 f0 ff ff       	jmp    80105b07 <alltraps>

80106a1f <vector255>:
.globl vector255
vector255:
  pushl $0
80106a1f:	6a 00                	push   $0x0
  pushl $255
80106a21:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106a26:	e9 dc f0 ff ff       	jmp    80105b07 <alltraps>
80106a2b:	66 90                	xchg   %ax,%ax
80106a2d:	66 90                	xchg   %ax,%ax
80106a2f:	90                   	nop

80106a30 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80106a30:	55                   	push   %ebp
80106a31:	89 e5                	mov    %esp,%ebp
80106a33:	57                   	push   %edi
80106a34:	56                   	push   %esi
80106a35:	89 d6                	mov    %edx,%esi
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80106a37:	c1 ea 16             	shr    $0x16,%edx
{
80106a3a:	53                   	push   %ebx
  pde = &pgdir[PDX(va)];
80106a3b:	8d 3c 90             	lea    (%eax,%edx,4),%edi
{
80106a3e:	83 ec 0c             	sub    $0xc,%esp
  if(*pde & PTE_P){
80106a41:	8b 1f                	mov    (%edi),%ebx
80106a43:	f6 c3 01             	test   $0x1,%bl
80106a46:	74 28                	je     80106a70 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106a48:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
80106a4e:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80106a54:	89 f0                	mov    %esi,%eax
}
80106a56:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return &pgtab[PTX(va)];
80106a59:	c1 e8 0a             	shr    $0xa,%eax
80106a5c:	25 fc 0f 00 00       	and    $0xffc,%eax
80106a61:	01 d8                	add    %ebx,%eax
}
80106a63:	5b                   	pop    %ebx
80106a64:	5e                   	pop    %esi
80106a65:	5f                   	pop    %edi
80106a66:	5d                   	pop    %ebp
80106a67:	c3                   	ret    
80106a68:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106a6f:	90                   	nop
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106a70:	85 c9                	test   %ecx,%ecx
80106a72:	74 2c                	je     80106aa0 <walkpgdir+0x70>
80106a74:	e8 d7 bd ff ff       	call   80102850 <kalloc>
80106a79:	89 c3                	mov    %eax,%ebx
80106a7b:	85 c0                	test   %eax,%eax
80106a7d:	74 21                	je     80106aa0 <walkpgdir+0x70>
    memset(pgtab, 0, PGSIZE);
80106a7f:	83 ec 04             	sub    $0x4,%esp
80106a82:	68 00 10 00 00       	push   $0x1000
80106a87:	6a 00                	push   $0x0
80106a89:	50                   	push   %eax
80106a8a:	e8 11 de ff ff       	call   801048a0 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106a8f:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106a95:	83 c4 10             	add    $0x10,%esp
80106a98:	83 c8 07             	or     $0x7,%eax
80106a9b:	89 07                	mov    %eax,(%edi)
80106a9d:	eb b5                	jmp    80106a54 <walkpgdir+0x24>
80106a9f:	90                   	nop
}
80106aa0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
80106aa3:	31 c0                	xor    %eax,%eax
}
80106aa5:	5b                   	pop    %ebx
80106aa6:	5e                   	pop    %esi
80106aa7:	5f                   	pop    %edi
80106aa8:	5d                   	pop    %ebp
80106aa9:	c3                   	ret    
80106aaa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106ab0 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80106ab0:	55                   	push   %ebp
80106ab1:	89 e5                	mov    %esp,%ebp
80106ab3:	57                   	push   %edi
80106ab4:	89 c7                	mov    %eax,%edi
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106ab6:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
{
80106aba:	56                   	push   %esi
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106abb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  a = (char*)PGROUNDDOWN((uint)va);
80106ac0:	89 d6                	mov    %edx,%esi
{
80106ac2:	53                   	push   %ebx
  a = (char*)PGROUNDDOWN((uint)va);
80106ac3:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
{
80106ac9:	83 ec 1c             	sub    $0x1c,%esp
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106acc:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106acf:	8b 45 08             	mov    0x8(%ebp),%eax
80106ad2:	29 f0                	sub    %esi,%eax
80106ad4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106ad7:	eb 1f                	jmp    80106af8 <mappages+0x48>
80106ad9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
80106ae0:	f6 00 01             	testb  $0x1,(%eax)
80106ae3:	75 45                	jne    80106b2a <mappages+0x7a>
      panic("remap");
    *pte = pa | perm | PTE_P;
80106ae5:	0b 5d 0c             	or     0xc(%ebp),%ebx
80106ae8:	83 cb 01             	or     $0x1,%ebx
80106aeb:	89 18                	mov    %ebx,(%eax)
    if(a == last)
80106aed:	3b 75 e0             	cmp    -0x20(%ebp),%esi
80106af0:	74 2e                	je     80106b20 <mappages+0x70>
      break;
    a += PGSIZE;
80106af2:	81 c6 00 10 00 00    	add    $0x1000,%esi
  for(;;){
80106af8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80106afb:	b9 01 00 00 00       	mov    $0x1,%ecx
80106b00:	89 f2                	mov    %esi,%edx
80106b02:	8d 1c 06             	lea    (%esi,%eax,1),%ebx
80106b05:	89 f8                	mov    %edi,%eax
80106b07:	e8 24 ff ff ff       	call   80106a30 <walkpgdir>
80106b0c:	85 c0                	test   %eax,%eax
80106b0e:	75 d0                	jne    80106ae0 <mappages+0x30>
    pa += PGSIZE;
  }
  return 0;
}
80106b10:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106b13:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106b18:	5b                   	pop    %ebx
80106b19:	5e                   	pop    %esi
80106b1a:	5f                   	pop    %edi
80106b1b:	5d                   	pop    %ebp
80106b1c:	c3                   	ret    
80106b1d:	8d 76 00             	lea    0x0(%esi),%esi
80106b20:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106b23:	31 c0                	xor    %eax,%eax
}
80106b25:	5b                   	pop    %ebx
80106b26:	5e                   	pop    %esi
80106b27:	5f                   	pop    %edi
80106b28:	5d                   	pop    %ebp
80106b29:	c3                   	ret    
      panic("remap");
80106b2a:	83 ec 0c             	sub    $0xc,%esp
80106b2d:	68 30 7c 10 80       	push   $0x80107c30
80106b32:	e8 59 98 ff ff       	call   80100390 <panic>
80106b37:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106b3e:	66 90                	xchg   %ax,%ax

80106b40 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106b40:	55                   	push   %ebp
80106b41:	89 e5                	mov    %esp,%ebp
80106b43:	57                   	push   %edi
80106b44:	56                   	push   %esi
80106b45:	89 c6                	mov    %eax,%esi
80106b47:	53                   	push   %ebx
80106b48:	89 d3                	mov    %edx,%ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80106b4a:	8d 91 ff 0f 00 00    	lea    0xfff(%ecx),%edx
80106b50:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106b56:	83 ec 1c             	sub    $0x1c,%esp
80106b59:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80106b5c:	39 da                	cmp    %ebx,%edx
80106b5e:	73 5b                	jae    80106bbb <deallocuvm.part.0+0x7b>
80106b60:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80106b63:	89 d7                	mov    %edx,%edi
80106b65:	eb 14                	jmp    80106b7b <deallocuvm.part.0+0x3b>
80106b67:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106b6e:	66 90                	xchg   %ax,%ax
80106b70:	81 c7 00 10 00 00    	add    $0x1000,%edi
80106b76:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80106b79:	76 40                	jbe    80106bbb <deallocuvm.part.0+0x7b>
    pte = walkpgdir(pgdir, (char*)a, 0);
80106b7b:	31 c9                	xor    %ecx,%ecx
80106b7d:	89 fa                	mov    %edi,%edx
80106b7f:	89 f0                	mov    %esi,%eax
80106b81:	e8 aa fe ff ff       	call   80106a30 <walkpgdir>
80106b86:	89 c3                	mov    %eax,%ebx
    if(!pte)
80106b88:	85 c0                	test   %eax,%eax
80106b8a:	74 44                	je     80106bd0 <deallocuvm.part.0+0x90>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
80106b8c:	8b 00                	mov    (%eax),%eax
80106b8e:	a8 01                	test   $0x1,%al
80106b90:	74 de                	je     80106b70 <deallocuvm.part.0+0x30>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
80106b92:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106b97:	74 47                	je     80106be0 <deallocuvm.part.0+0xa0>
        panic("kfree");
      char *v = P2V(pa);
      kfree(v);
80106b99:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
80106b9c:	05 00 00 00 80       	add    $0x80000000,%eax
80106ba1:	81 c7 00 10 00 00    	add    $0x1000,%edi
      kfree(v);
80106ba7:	50                   	push   %eax
80106ba8:	e8 e3 ba ff ff       	call   80102690 <kfree>
      *pte = 0;
80106bad:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80106bb3:	83 c4 10             	add    $0x10,%esp
  for(; a  < oldsz; a += PGSIZE){
80106bb6:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80106bb9:	77 c0                	ja     80106b7b <deallocuvm.part.0+0x3b>
    }
  }
  return newsz;
}
80106bbb:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106bbe:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106bc1:	5b                   	pop    %ebx
80106bc2:	5e                   	pop    %esi
80106bc3:	5f                   	pop    %edi
80106bc4:	5d                   	pop    %ebp
80106bc5:	c3                   	ret    
80106bc6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106bcd:	8d 76 00             	lea    0x0(%esi),%esi
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80106bd0:	89 fa                	mov    %edi,%edx
80106bd2:	81 e2 00 00 c0 ff    	and    $0xffc00000,%edx
80106bd8:	8d ba 00 00 40 00    	lea    0x400000(%edx),%edi
80106bde:	eb 96                	jmp    80106b76 <deallocuvm.part.0+0x36>
        panic("kfree");
80106be0:	83 ec 0c             	sub    $0xc,%esp
80106be3:	68 e6 75 10 80       	push   $0x801075e6
80106be8:	e8 a3 97 ff ff       	call   80100390 <panic>
80106bed:	8d 76 00             	lea    0x0(%esi),%esi

80106bf0 <seginit>:
{
80106bf0:	f3 0f 1e fb          	endbr32 
80106bf4:	55                   	push   %ebp
80106bf5:	89 e5                	mov    %esp,%ebp
80106bf7:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80106bfa:	e8 71 cf ff ff       	call   80103b70 <cpuid>
  pd[0] = size-1;
80106bff:	ba 2f 00 00 00       	mov    $0x2f,%edx
80106c04:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80106c0a:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106c0e:	c7 80 18 28 11 80 ff 	movl   $0xffff,-0x7feed7e8(%eax)
80106c15:	ff 00 00 
80106c18:	c7 80 1c 28 11 80 00 	movl   $0xcf9a00,-0x7feed7e4(%eax)
80106c1f:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106c22:	c7 80 20 28 11 80 ff 	movl   $0xffff,-0x7feed7e0(%eax)
80106c29:	ff 00 00 
80106c2c:	c7 80 24 28 11 80 00 	movl   $0xcf9200,-0x7feed7dc(%eax)
80106c33:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106c36:	c7 80 28 28 11 80 ff 	movl   $0xffff,-0x7feed7d8(%eax)
80106c3d:	ff 00 00 
80106c40:	c7 80 2c 28 11 80 00 	movl   $0xcffa00,-0x7feed7d4(%eax)
80106c47:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106c4a:	c7 80 30 28 11 80 ff 	movl   $0xffff,-0x7feed7d0(%eax)
80106c51:	ff 00 00 
80106c54:	c7 80 34 28 11 80 00 	movl   $0xcff200,-0x7feed7cc(%eax)
80106c5b:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
80106c5e:	05 10 28 11 80       	add    $0x80112810,%eax
  pd[1] = (uint)p;
80106c63:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80106c67:	c1 e8 10             	shr    $0x10,%eax
80106c6a:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80106c6e:	8d 45 f2             	lea    -0xe(%ebp),%eax
80106c71:	0f 01 10             	lgdtl  (%eax)
}
80106c74:	c9                   	leave  
80106c75:	c3                   	ret    
80106c76:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106c7d:	8d 76 00             	lea    0x0(%esi),%esi

80106c80 <switchkvm>:
{
80106c80:	f3 0f 1e fb          	endbr32 
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106c84:	a1 c4 55 11 80       	mov    0x801155c4,%eax
80106c89:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106c8e:	0f 22 d8             	mov    %eax,%cr3
}
80106c91:	c3                   	ret    
80106c92:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106c99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106ca0 <switchuvm>:
{
80106ca0:	f3 0f 1e fb          	endbr32 
80106ca4:	55                   	push   %ebp
80106ca5:	89 e5                	mov    %esp,%ebp
80106ca7:	57                   	push   %edi
80106ca8:	56                   	push   %esi
80106ca9:	53                   	push   %ebx
80106caa:	83 ec 1c             	sub    $0x1c,%esp
80106cad:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
80106cb0:	85 f6                	test   %esi,%esi
80106cb2:	0f 84 cb 00 00 00    	je     80106d83 <switchuvm+0xe3>
  if(p->kstack == 0)
80106cb8:	8b 46 08             	mov    0x8(%esi),%eax
80106cbb:	85 c0                	test   %eax,%eax
80106cbd:	0f 84 da 00 00 00    	je     80106d9d <switchuvm+0xfd>
  if(p->pgdir == 0)
80106cc3:	8b 46 04             	mov    0x4(%esi),%eax
80106cc6:	85 c0                	test   %eax,%eax
80106cc8:	0f 84 c2 00 00 00    	je     80106d90 <switchuvm+0xf0>
  pushcli();
80106cce:	e8 bd d9 ff ff       	call   80104690 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106cd3:	e8 28 ce ff ff       	call   80103b00 <mycpu>
80106cd8:	89 c3                	mov    %eax,%ebx
80106cda:	e8 21 ce ff ff       	call   80103b00 <mycpu>
80106cdf:	89 c7                	mov    %eax,%edi
80106ce1:	e8 1a ce ff ff       	call   80103b00 <mycpu>
80106ce6:	83 c7 08             	add    $0x8,%edi
80106ce9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106cec:	e8 0f ce ff ff       	call   80103b00 <mycpu>
80106cf1:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106cf4:	ba 67 00 00 00       	mov    $0x67,%edx
80106cf9:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80106d00:	83 c0 08             	add    $0x8,%eax
80106d03:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106d0a:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106d0f:	83 c1 08             	add    $0x8,%ecx
80106d12:	c1 e8 18             	shr    $0x18,%eax
80106d15:	c1 e9 10             	shr    $0x10,%ecx
80106d18:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
80106d1e:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
80106d24:	b9 99 40 00 00       	mov    $0x4099,%ecx
80106d29:	66 89 8b 9d 00 00 00 	mov    %cx,0x9d(%ebx)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106d30:	bb 10 00 00 00       	mov    $0x10,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
80106d35:	e8 c6 cd ff ff       	call   80103b00 <mycpu>
80106d3a:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106d41:	e8 ba cd ff ff       	call   80103b00 <mycpu>
80106d46:	66 89 58 10          	mov    %bx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80106d4a:	8b 5e 08             	mov    0x8(%esi),%ebx
80106d4d:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106d53:	e8 a8 cd ff ff       	call   80103b00 <mycpu>
80106d58:	89 58 0c             	mov    %ebx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106d5b:	e8 a0 cd ff ff       	call   80103b00 <mycpu>
80106d60:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80106d64:	b8 28 00 00 00       	mov    $0x28,%eax
80106d69:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
80106d6c:	8b 46 04             	mov    0x4(%esi),%eax
80106d6f:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106d74:	0f 22 d8             	mov    %eax,%cr3
}
80106d77:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106d7a:	5b                   	pop    %ebx
80106d7b:	5e                   	pop    %esi
80106d7c:	5f                   	pop    %edi
80106d7d:	5d                   	pop    %ebp
  popcli();
80106d7e:	e9 5d d9 ff ff       	jmp    801046e0 <popcli>
    panic("switchuvm: no process");
80106d83:	83 ec 0c             	sub    $0xc,%esp
80106d86:	68 36 7c 10 80       	push   $0x80107c36
80106d8b:	e8 00 96 ff ff       	call   80100390 <panic>
    panic("switchuvm: no pgdir");
80106d90:	83 ec 0c             	sub    $0xc,%esp
80106d93:	68 61 7c 10 80       	push   $0x80107c61
80106d98:	e8 f3 95 ff ff       	call   80100390 <panic>
    panic("switchuvm: no kstack");
80106d9d:	83 ec 0c             	sub    $0xc,%esp
80106da0:	68 4c 7c 10 80       	push   $0x80107c4c
80106da5:	e8 e6 95 ff ff       	call   80100390 <panic>
80106daa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106db0 <inituvm>:
{
80106db0:	f3 0f 1e fb          	endbr32 
80106db4:	55                   	push   %ebp
80106db5:	89 e5                	mov    %esp,%ebp
80106db7:	57                   	push   %edi
80106db8:	56                   	push   %esi
80106db9:	53                   	push   %ebx
80106dba:	83 ec 1c             	sub    $0x1c,%esp
80106dbd:	8b 45 0c             	mov    0xc(%ebp),%eax
80106dc0:	8b 75 10             	mov    0x10(%ebp),%esi
80106dc3:	8b 7d 08             	mov    0x8(%ebp),%edi
80106dc6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
80106dc9:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80106dcf:	77 4b                	ja     80106e1c <inituvm+0x6c>
  mem = kalloc();
80106dd1:	e8 7a ba ff ff       	call   80102850 <kalloc>
  memset(mem, 0, PGSIZE);
80106dd6:	83 ec 04             	sub    $0x4,%esp
80106dd9:	68 00 10 00 00       	push   $0x1000
  mem = kalloc();
80106dde:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80106de0:	6a 00                	push   $0x0
80106de2:	50                   	push   %eax
80106de3:	e8 b8 da ff ff       	call   801048a0 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80106de8:	58                   	pop    %eax
80106de9:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106def:	5a                   	pop    %edx
80106df0:	6a 06                	push   $0x6
80106df2:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106df7:	31 d2                	xor    %edx,%edx
80106df9:	50                   	push   %eax
80106dfa:	89 f8                	mov    %edi,%eax
80106dfc:	e8 af fc ff ff       	call   80106ab0 <mappages>
  memmove(mem, init, sz);
80106e01:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106e04:	89 75 10             	mov    %esi,0x10(%ebp)
80106e07:	83 c4 10             	add    $0x10,%esp
80106e0a:	89 5d 08             	mov    %ebx,0x8(%ebp)
80106e0d:	89 45 0c             	mov    %eax,0xc(%ebp)
}
80106e10:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106e13:	5b                   	pop    %ebx
80106e14:	5e                   	pop    %esi
80106e15:	5f                   	pop    %edi
80106e16:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80106e17:	e9 24 db ff ff       	jmp    80104940 <memmove>
    panic("inituvm: more than a page");
80106e1c:	83 ec 0c             	sub    $0xc,%esp
80106e1f:	68 75 7c 10 80       	push   $0x80107c75
80106e24:	e8 67 95 ff ff       	call   80100390 <panic>
80106e29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106e30 <loaduvm>:
{
80106e30:	f3 0f 1e fb          	endbr32 
80106e34:	55                   	push   %ebp
80106e35:	89 e5                	mov    %esp,%ebp
80106e37:	57                   	push   %edi
80106e38:	56                   	push   %esi
80106e39:	53                   	push   %ebx
80106e3a:	83 ec 1c             	sub    $0x1c,%esp
80106e3d:	8b 45 0c             	mov    0xc(%ebp),%eax
80106e40:	8b 75 18             	mov    0x18(%ebp),%esi
  if((uint) addr % PGSIZE != 0)
80106e43:	a9 ff 0f 00 00       	test   $0xfff,%eax
80106e48:	0f 85 99 00 00 00    	jne    80106ee7 <loaduvm+0xb7>
  for(i = 0; i < sz; i += PGSIZE){
80106e4e:	01 f0                	add    %esi,%eax
80106e50:	89 f3                	mov    %esi,%ebx
80106e52:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106e55:	8b 45 14             	mov    0x14(%ebp),%eax
80106e58:	01 f0                	add    %esi,%eax
80106e5a:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(i = 0; i < sz; i += PGSIZE){
80106e5d:	85 f6                	test   %esi,%esi
80106e5f:	75 15                	jne    80106e76 <loaduvm+0x46>
80106e61:	eb 6d                	jmp    80106ed0 <loaduvm+0xa0>
80106e63:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106e67:	90                   	nop
80106e68:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
80106e6e:	89 f0                	mov    %esi,%eax
80106e70:	29 d8                	sub    %ebx,%eax
80106e72:	39 c6                	cmp    %eax,%esi
80106e74:	76 5a                	jbe    80106ed0 <loaduvm+0xa0>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80106e76:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80106e79:	8b 45 08             	mov    0x8(%ebp),%eax
80106e7c:	31 c9                	xor    %ecx,%ecx
80106e7e:	29 da                	sub    %ebx,%edx
80106e80:	e8 ab fb ff ff       	call   80106a30 <walkpgdir>
80106e85:	85 c0                	test   %eax,%eax
80106e87:	74 51                	je     80106eda <loaduvm+0xaa>
    pa = PTE_ADDR(*pte);
80106e89:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106e8b:	8b 4d e0             	mov    -0x20(%ebp),%ecx
    if(sz - i < PGSIZE)
80106e8e:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
80106e93:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
80106e98:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
80106e9e:	0f 46 fb             	cmovbe %ebx,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106ea1:	29 d9                	sub    %ebx,%ecx
80106ea3:	05 00 00 00 80       	add    $0x80000000,%eax
80106ea8:	57                   	push   %edi
80106ea9:	51                   	push   %ecx
80106eaa:	50                   	push   %eax
80106eab:	ff 75 10             	pushl  0x10(%ebp)
80106eae:	e8 cd ad ff ff       	call   80101c80 <readi>
80106eb3:	83 c4 10             	add    $0x10,%esp
80106eb6:	39 f8                	cmp    %edi,%eax
80106eb8:	74 ae                	je     80106e68 <loaduvm+0x38>
}
80106eba:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106ebd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106ec2:	5b                   	pop    %ebx
80106ec3:	5e                   	pop    %esi
80106ec4:	5f                   	pop    %edi
80106ec5:	5d                   	pop    %ebp
80106ec6:	c3                   	ret    
80106ec7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106ece:	66 90                	xchg   %ax,%ax
80106ed0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106ed3:	31 c0                	xor    %eax,%eax
}
80106ed5:	5b                   	pop    %ebx
80106ed6:	5e                   	pop    %esi
80106ed7:	5f                   	pop    %edi
80106ed8:	5d                   	pop    %ebp
80106ed9:	c3                   	ret    
      panic("loaduvm: address should exist");
80106eda:	83 ec 0c             	sub    $0xc,%esp
80106edd:	68 8f 7c 10 80       	push   $0x80107c8f
80106ee2:	e8 a9 94 ff ff       	call   80100390 <panic>
    panic("loaduvm: addr must be page aligned");
80106ee7:	83 ec 0c             	sub    $0xc,%esp
80106eea:	68 30 7d 10 80       	push   $0x80107d30
80106eef:	e8 9c 94 ff ff       	call   80100390 <panic>
80106ef4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106efb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106eff:	90                   	nop

80106f00 <allocuvm>:
{
80106f00:	f3 0f 1e fb          	endbr32 
80106f04:	55                   	push   %ebp
80106f05:	89 e5                	mov    %esp,%ebp
80106f07:	57                   	push   %edi
80106f08:	56                   	push   %esi
80106f09:	53                   	push   %ebx
80106f0a:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
80106f0d:	8b 45 10             	mov    0x10(%ebp),%eax
{
80106f10:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(newsz >= KERNBASE)
80106f13:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106f16:	85 c0                	test   %eax,%eax
80106f18:	0f 88 b2 00 00 00    	js     80106fd0 <allocuvm+0xd0>
  if(newsz < oldsz)
80106f1e:	3b 45 0c             	cmp    0xc(%ebp),%eax
    return oldsz;
80106f21:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(newsz < oldsz)
80106f24:	0f 82 96 00 00 00    	jb     80106fc0 <allocuvm+0xc0>
  a = PGROUNDUP(oldsz);
80106f2a:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
80106f30:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  for(; a < newsz; a += PGSIZE){
80106f36:	39 75 10             	cmp    %esi,0x10(%ebp)
80106f39:	77 40                	ja     80106f7b <allocuvm+0x7b>
80106f3b:	e9 83 00 00 00       	jmp    80106fc3 <allocuvm+0xc3>
    memset(mem, 0, PGSIZE);
80106f40:	83 ec 04             	sub    $0x4,%esp
80106f43:	68 00 10 00 00       	push   $0x1000
80106f48:	6a 00                	push   $0x0
80106f4a:	50                   	push   %eax
80106f4b:	e8 50 d9 ff ff       	call   801048a0 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80106f50:	58                   	pop    %eax
80106f51:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106f57:	5a                   	pop    %edx
80106f58:	6a 06                	push   $0x6
80106f5a:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106f5f:	89 f2                	mov    %esi,%edx
80106f61:	50                   	push   %eax
80106f62:	89 f8                	mov    %edi,%eax
80106f64:	e8 47 fb ff ff       	call   80106ab0 <mappages>
80106f69:	83 c4 10             	add    $0x10,%esp
80106f6c:	85 c0                	test   %eax,%eax
80106f6e:	78 78                	js     80106fe8 <allocuvm+0xe8>
  for(; a < newsz; a += PGSIZE){
80106f70:	81 c6 00 10 00 00    	add    $0x1000,%esi
80106f76:	39 75 10             	cmp    %esi,0x10(%ebp)
80106f79:	76 48                	jbe    80106fc3 <allocuvm+0xc3>
    mem = kalloc();
80106f7b:	e8 d0 b8 ff ff       	call   80102850 <kalloc>
80106f80:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
80106f82:	85 c0                	test   %eax,%eax
80106f84:	75 ba                	jne    80106f40 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
80106f86:	83 ec 0c             	sub    $0xc,%esp
80106f89:	68 ad 7c 10 80       	push   $0x80107cad
80106f8e:	e8 8d 97 ff ff       	call   80100720 <cprintf>
  if(newsz >= oldsz)
80106f93:	8b 45 0c             	mov    0xc(%ebp),%eax
80106f96:	83 c4 10             	add    $0x10,%esp
80106f99:	39 45 10             	cmp    %eax,0x10(%ebp)
80106f9c:	74 32                	je     80106fd0 <allocuvm+0xd0>
80106f9e:	8b 55 10             	mov    0x10(%ebp),%edx
80106fa1:	89 c1                	mov    %eax,%ecx
80106fa3:	89 f8                	mov    %edi,%eax
80106fa5:	e8 96 fb ff ff       	call   80106b40 <deallocuvm.part.0>
      return 0;
80106faa:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80106fb1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106fb4:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106fb7:	5b                   	pop    %ebx
80106fb8:	5e                   	pop    %esi
80106fb9:	5f                   	pop    %edi
80106fba:	5d                   	pop    %ebp
80106fbb:	c3                   	ret    
80106fbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return oldsz;
80106fc0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
}
80106fc3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106fc6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106fc9:	5b                   	pop    %ebx
80106fca:	5e                   	pop    %esi
80106fcb:	5f                   	pop    %edi
80106fcc:	5d                   	pop    %ebp
80106fcd:	c3                   	ret    
80106fce:	66 90                	xchg   %ax,%ax
    return 0;
80106fd0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80106fd7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106fda:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106fdd:	5b                   	pop    %ebx
80106fde:	5e                   	pop    %esi
80106fdf:	5f                   	pop    %edi
80106fe0:	5d                   	pop    %ebp
80106fe1:	c3                   	ret    
80106fe2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
80106fe8:	83 ec 0c             	sub    $0xc,%esp
80106feb:	68 c5 7c 10 80       	push   $0x80107cc5
80106ff0:	e8 2b 97 ff ff       	call   80100720 <cprintf>
  if(newsz >= oldsz)
80106ff5:	8b 45 0c             	mov    0xc(%ebp),%eax
80106ff8:	83 c4 10             	add    $0x10,%esp
80106ffb:	39 45 10             	cmp    %eax,0x10(%ebp)
80106ffe:	74 0c                	je     8010700c <allocuvm+0x10c>
80107000:	8b 55 10             	mov    0x10(%ebp),%edx
80107003:	89 c1                	mov    %eax,%ecx
80107005:	89 f8                	mov    %edi,%eax
80107007:	e8 34 fb ff ff       	call   80106b40 <deallocuvm.part.0>
      kfree(mem);
8010700c:	83 ec 0c             	sub    $0xc,%esp
8010700f:	53                   	push   %ebx
80107010:	e8 7b b6 ff ff       	call   80102690 <kfree>
      return 0;
80107015:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
8010701c:	83 c4 10             	add    $0x10,%esp
}
8010701f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107022:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107025:	5b                   	pop    %ebx
80107026:	5e                   	pop    %esi
80107027:	5f                   	pop    %edi
80107028:	5d                   	pop    %ebp
80107029:	c3                   	ret    
8010702a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107030 <deallocuvm>:
{
80107030:	f3 0f 1e fb          	endbr32 
80107034:	55                   	push   %ebp
80107035:	89 e5                	mov    %esp,%ebp
80107037:	8b 55 0c             	mov    0xc(%ebp),%edx
8010703a:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010703d:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
80107040:	39 d1                	cmp    %edx,%ecx
80107042:	73 0c                	jae    80107050 <deallocuvm+0x20>
}
80107044:	5d                   	pop    %ebp
80107045:	e9 f6 fa ff ff       	jmp    80106b40 <deallocuvm.part.0>
8010704a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107050:	89 d0                	mov    %edx,%eax
80107052:	5d                   	pop    %ebp
80107053:	c3                   	ret    
80107054:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010705b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010705f:	90                   	nop

80107060 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80107060:	f3 0f 1e fb          	endbr32 
80107064:	55                   	push   %ebp
80107065:	89 e5                	mov    %esp,%ebp
80107067:	57                   	push   %edi
80107068:	56                   	push   %esi
80107069:	53                   	push   %ebx
8010706a:	83 ec 0c             	sub    $0xc,%esp
8010706d:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
80107070:	85 f6                	test   %esi,%esi
80107072:	74 55                	je     801070c9 <freevm+0x69>
  if(newsz >= oldsz)
80107074:	31 c9                	xor    %ecx,%ecx
80107076:	ba 00 00 00 80       	mov    $0x80000000,%edx
8010707b:	89 f0                	mov    %esi,%eax
8010707d:	89 f3                	mov    %esi,%ebx
8010707f:	e8 bc fa ff ff       	call   80106b40 <deallocuvm.part.0>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80107084:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
8010708a:	eb 0b                	jmp    80107097 <freevm+0x37>
8010708c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107090:	83 c3 04             	add    $0x4,%ebx
80107093:	39 df                	cmp    %ebx,%edi
80107095:	74 23                	je     801070ba <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80107097:	8b 03                	mov    (%ebx),%eax
80107099:	a8 01                	test   $0x1,%al
8010709b:	74 f3                	je     80107090 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
8010709d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
801070a2:	83 ec 0c             	sub    $0xc,%esp
801070a5:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
801070a8:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
801070ad:	50                   	push   %eax
801070ae:	e8 dd b5 ff ff       	call   80102690 <kfree>
801070b3:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
801070b6:	39 df                	cmp    %ebx,%edi
801070b8:	75 dd                	jne    80107097 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
801070ba:	89 75 08             	mov    %esi,0x8(%ebp)
}
801070bd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801070c0:	5b                   	pop    %ebx
801070c1:	5e                   	pop    %esi
801070c2:	5f                   	pop    %edi
801070c3:	5d                   	pop    %ebp
  kfree((char*)pgdir);
801070c4:	e9 c7 b5 ff ff       	jmp    80102690 <kfree>
    panic("freevm: no pgdir");
801070c9:	83 ec 0c             	sub    $0xc,%esp
801070cc:	68 e1 7c 10 80       	push   $0x80107ce1
801070d1:	e8 ba 92 ff ff       	call   80100390 <panic>
801070d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801070dd:	8d 76 00             	lea    0x0(%esi),%esi

801070e0 <setupkvm>:
{
801070e0:	f3 0f 1e fb          	endbr32 
801070e4:	55                   	push   %ebp
801070e5:	89 e5                	mov    %esp,%ebp
801070e7:	56                   	push   %esi
801070e8:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
801070e9:	e8 62 b7 ff ff       	call   80102850 <kalloc>
801070ee:	89 c6                	mov    %eax,%esi
801070f0:	85 c0                	test   %eax,%eax
801070f2:	74 42                	je     80107136 <setupkvm+0x56>
  memset(pgdir, 0, PGSIZE);
801070f4:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801070f7:	bb 20 a4 10 80       	mov    $0x8010a420,%ebx
  memset(pgdir, 0, PGSIZE);
801070fc:	68 00 10 00 00       	push   $0x1000
80107101:	6a 00                	push   $0x0
80107103:	50                   	push   %eax
80107104:	e8 97 d7 ff ff       	call   801048a0 <memset>
80107109:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
8010710c:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
8010710f:	83 ec 08             	sub    $0x8,%esp
80107112:	8b 4b 08             	mov    0x8(%ebx),%ecx
80107115:	ff 73 0c             	pushl  0xc(%ebx)
80107118:	8b 13                	mov    (%ebx),%edx
8010711a:	50                   	push   %eax
8010711b:	29 c1                	sub    %eax,%ecx
8010711d:	89 f0                	mov    %esi,%eax
8010711f:	e8 8c f9 ff ff       	call   80106ab0 <mappages>
80107124:	83 c4 10             	add    $0x10,%esp
80107127:	85 c0                	test   %eax,%eax
80107129:	78 15                	js     80107140 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
8010712b:	83 c3 10             	add    $0x10,%ebx
8010712e:	81 fb 60 a4 10 80    	cmp    $0x8010a460,%ebx
80107134:	75 d6                	jne    8010710c <setupkvm+0x2c>
}
80107136:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107139:	89 f0                	mov    %esi,%eax
8010713b:	5b                   	pop    %ebx
8010713c:	5e                   	pop    %esi
8010713d:	5d                   	pop    %ebp
8010713e:	c3                   	ret    
8010713f:	90                   	nop
      freevm(pgdir);
80107140:	83 ec 0c             	sub    $0xc,%esp
80107143:	56                   	push   %esi
      return 0;
80107144:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
80107146:	e8 15 ff ff ff       	call   80107060 <freevm>
      return 0;
8010714b:	83 c4 10             	add    $0x10,%esp
}
8010714e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107151:	89 f0                	mov    %esi,%eax
80107153:	5b                   	pop    %ebx
80107154:	5e                   	pop    %esi
80107155:	5d                   	pop    %ebp
80107156:	c3                   	ret    
80107157:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010715e:	66 90                	xchg   %ax,%ax

80107160 <kvmalloc>:
{
80107160:	f3 0f 1e fb          	endbr32 
80107164:	55                   	push   %ebp
80107165:	89 e5                	mov    %esp,%ebp
80107167:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
8010716a:	e8 71 ff ff ff       	call   801070e0 <setupkvm>
8010716f:	a3 c4 55 11 80       	mov    %eax,0x801155c4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107174:	05 00 00 00 80       	add    $0x80000000,%eax
80107179:	0f 22 d8             	mov    %eax,%cr3
}
8010717c:	c9                   	leave  
8010717d:	c3                   	ret    
8010717e:	66 90                	xchg   %ax,%ax

80107180 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80107180:	f3 0f 1e fb          	endbr32 
80107184:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107185:	31 c9                	xor    %ecx,%ecx
{
80107187:	89 e5                	mov    %esp,%ebp
80107189:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
8010718c:	8b 55 0c             	mov    0xc(%ebp),%edx
8010718f:	8b 45 08             	mov    0x8(%ebp),%eax
80107192:	e8 99 f8 ff ff       	call   80106a30 <walkpgdir>
  if(pte == 0)
80107197:	85 c0                	test   %eax,%eax
80107199:	74 05                	je     801071a0 <clearpteu+0x20>
    panic("clearpteu");
  *pte &= ~PTE_U;
8010719b:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
8010719e:	c9                   	leave  
8010719f:	c3                   	ret    
    panic("clearpteu");
801071a0:	83 ec 0c             	sub    $0xc,%esp
801071a3:	68 f2 7c 10 80       	push   $0x80107cf2
801071a8:	e8 e3 91 ff ff       	call   80100390 <panic>
801071ad:	8d 76 00             	lea    0x0(%esi),%esi

801071b0 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
801071b0:	f3 0f 1e fb          	endbr32 
801071b4:	55                   	push   %ebp
801071b5:	89 e5                	mov    %esp,%ebp
801071b7:	57                   	push   %edi
801071b8:	56                   	push   %esi
801071b9:	53                   	push   %ebx
801071ba:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
801071bd:	e8 1e ff ff ff       	call   801070e0 <setupkvm>
801071c2:	89 45 e0             	mov    %eax,-0x20(%ebp)
801071c5:	85 c0                	test   %eax,%eax
801071c7:	0f 84 9b 00 00 00    	je     80107268 <copyuvm+0xb8>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
801071cd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801071d0:	85 c9                	test   %ecx,%ecx
801071d2:	0f 84 90 00 00 00    	je     80107268 <copyuvm+0xb8>
801071d8:	31 f6                	xor    %esi,%esi
801071da:	eb 46                	jmp    80107222 <copyuvm+0x72>
801071dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
801071e0:	83 ec 04             	sub    $0x4,%esp
801071e3:	81 c7 00 00 00 80    	add    $0x80000000,%edi
801071e9:	68 00 10 00 00       	push   $0x1000
801071ee:	57                   	push   %edi
801071ef:	50                   	push   %eax
801071f0:	e8 4b d7 ff ff       	call   80104940 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
801071f5:	58                   	pop    %eax
801071f6:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801071fc:	5a                   	pop    %edx
801071fd:	ff 75 e4             	pushl  -0x1c(%ebp)
80107200:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107205:	89 f2                	mov    %esi,%edx
80107207:	50                   	push   %eax
80107208:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010720b:	e8 a0 f8 ff ff       	call   80106ab0 <mappages>
80107210:	83 c4 10             	add    $0x10,%esp
80107213:	85 c0                	test   %eax,%eax
80107215:	78 61                	js     80107278 <copyuvm+0xc8>
  for(i = 0; i < sz; i += PGSIZE){
80107217:	81 c6 00 10 00 00    	add    $0x1000,%esi
8010721d:	39 75 0c             	cmp    %esi,0xc(%ebp)
80107220:	76 46                	jbe    80107268 <copyuvm+0xb8>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107222:	8b 45 08             	mov    0x8(%ebp),%eax
80107225:	31 c9                	xor    %ecx,%ecx
80107227:	89 f2                	mov    %esi,%edx
80107229:	e8 02 f8 ff ff       	call   80106a30 <walkpgdir>
8010722e:	85 c0                	test   %eax,%eax
80107230:	74 61                	je     80107293 <copyuvm+0xe3>
    if(!(*pte & PTE_P))
80107232:	8b 00                	mov    (%eax),%eax
80107234:	a8 01                	test   $0x1,%al
80107236:	74 4e                	je     80107286 <copyuvm+0xd6>
    pa = PTE_ADDR(*pte);
80107238:	89 c7                	mov    %eax,%edi
    flags = PTE_FLAGS(*pte);
8010723a:	25 ff 0f 00 00       	and    $0xfff,%eax
8010723f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    pa = PTE_ADDR(*pte);
80107242:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if((mem = kalloc()) == 0)
80107248:	e8 03 b6 ff ff       	call   80102850 <kalloc>
8010724d:	89 c3                	mov    %eax,%ebx
8010724f:	85 c0                	test   %eax,%eax
80107251:	75 8d                	jne    801071e0 <copyuvm+0x30>
    }
  }
  return d;

bad:
  freevm(d);
80107253:	83 ec 0c             	sub    $0xc,%esp
80107256:	ff 75 e0             	pushl  -0x20(%ebp)
80107259:	e8 02 fe ff ff       	call   80107060 <freevm>
  return 0;
8010725e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
80107265:	83 c4 10             	add    $0x10,%esp
}
80107268:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010726b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010726e:	5b                   	pop    %ebx
8010726f:	5e                   	pop    %esi
80107270:	5f                   	pop    %edi
80107271:	5d                   	pop    %ebp
80107272:	c3                   	ret    
80107273:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107277:	90                   	nop
      kfree(mem);
80107278:	83 ec 0c             	sub    $0xc,%esp
8010727b:	53                   	push   %ebx
8010727c:	e8 0f b4 ff ff       	call   80102690 <kfree>
      goto bad;
80107281:	83 c4 10             	add    $0x10,%esp
80107284:	eb cd                	jmp    80107253 <copyuvm+0xa3>
      panic("copyuvm: page not present");
80107286:	83 ec 0c             	sub    $0xc,%esp
80107289:	68 16 7d 10 80       	push   $0x80107d16
8010728e:	e8 fd 90 ff ff       	call   80100390 <panic>
      panic("copyuvm: pte should exist");
80107293:	83 ec 0c             	sub    $0xc,%esp
80107296:	68 fc 7c 10 80       	push   $0x80107cfc
8010729b:	e8 f0 90 ff ff       	call   80100390 <panic>

801072a0 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
801072a0:	f3 0f 1e fb          	endbr32 
801072a4:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
801072a5:	31 c9                	xor    %ecx,%ecx
{
801072a7:	89 e5                	mov    %esp,%ebp
801072a9:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
801072ac:	8b 55 0c             	mov    0xc(%ebp),%edx
801072af:	8b 45 08             	mov    0x8(%ebp),%eax
801072b2:	e8 79 f7 ff ff       	call   80106a30 <walkpgdir>
  if((*pte & PTE_P) == 0)
801072b7:	8b 00                	mov    (%eax),%eax
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
801072b9:	c9                   	leave  
  if((*pte & PTE_U) == 0)
801072ba:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
801072bc:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
801072c1:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
801072c4:	05 00 00 00 80       	add    $0x80000000,%eax
801072c9:	83 fa 05             	cmp    $0x5,%edx
801072cc:	ba 00 00 00 00       	mov    $0x0,%edx
801072d1:	0f 45 c2             	cmovne %edx,%eax
}
801072d4:	c3                   	ret    
801072d5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801072dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801072e0 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
801072e0:	f3 0f 1e fb          	endbr32 
801072e4:	55                   	push   %ebp
801072e5:	89 e5                	mov    %esp,%ebp
801072e7:	57                   	push   %edi
801072e8:	56                   	push   %esi
801072e9:	53                   	push   %ebx
801072ea:	83 ec 0c             	sub    $0xc,%esp
801072ed:	8b 75 14             	mov    0x14(%ebp),%esi
801072f0:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
801072f3:	85 f6                	test   %esi,%esi
801072f5:	75 3c                	jne    80107333 <copyout+0x53>
801072f7:	eb 67                	jmp    80107360 <copyout+0x80>
801072f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80107300:	8b 55 0c             	mov    0xc(%ebp),%edx
80107303:	89 fb                	mov    %edi,%ebx
80107305:	29 d3                	sub    %edx,%ebx
80107307:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if(n > len)
8010730d:	39 f3                	cmp    %esi,%ebx
8010730f:	0f 47 de             	cmova  %esi,%ebx
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80107312:	29 fa                	sub    %edi,%edx
80107314:	83 ec 04             	sub    $0x4,%esp
80107317:	01 c2                	add    %eax,%edx
80107319:	53                   	push   %ebx
8010731a:	ff 75 10             	pushl  0x10(%ebp)
8010731d:	52                   	push   %edx
8010731e:	e8 1d d6 ff ff       	call   80104940 <memmove>
    len -= n;
    buf += n;
80107323:	01 5d 10             	add    %ebx,0x10(%ebp)
    va = va0 + PGSIZE;
80107326:	8d 97 00 10 00 00    	lea    0x1000(%edi),%edx
  while(len > 0){
8010732c:	83 c4 10             	add    $0x10,%esp
8010732f:	29 de                	sub    %ebx,%esi
80107331:	74 2d                	je     80107360 <copyout+0x80>
    va0 = (uint)PGROUNDDOWN(va);
80107333:	89 d7                	mov    %edx,%edi
    pa0 = uva2ka(pgdir, (char*)va0);
80107335:	83 ec 08             	sub    $0x8,%esp
    va0 = (uint)PGROUNDDOWN(va);
80107338:	89 55 0c             	mov    %edx,0xc(%ebp)
8010733b:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    pa0 = uva2ka(pgdir, (char*)va0);
80107341:	57                   	push   %edi
80107342:	ff 75 08             	pushl  0x8(%ebp)
80107345:	e8 56 ff ff ff       	call   801072a0 <uva2ka>
    if(pa0 == 0)
8010734a:	83 c4 10             	add    $0x10,%esp
8010734d:	85 c0                	test   %eax,%eax
8010734f:	75 af                	jne    80107300 <copyout+0x20>
  }
  return 0;
}
80107351:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107354:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107359:	5b                   	pop    %ebx
8010735a:	5e                   	pop    %esi
8010735b:	5f                   	pop    %edi
8010735c:	5d                   	pop    %ebp
8010735d:	c3                   	ret    
8010735e:	66 90                	xchg   %ax,%ax
80107360:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107363:	31 c0                	xor    %eax,%eax
}
80107365:	5b                   	pop    %ebx
80107366:	5e                   	pop    %esi
80107367:	5f                   	pop    %edi
80107368:	5d                   	pop    %ebp
80107369:	c3                   	ret    
