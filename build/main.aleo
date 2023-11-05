program donates.aleo;

struct DonateInfo:
    title as field;

struct MakeDonateInfo:
    amount as u64;
    id as field;

record DonateEvent:
    owner as address.private;
    id as field.private;

record Donate:
    owner as address.private;
    gates as u64.private;
    info as MakeDonateInfo.private;


mapping fieldInfo:
	key as field.public;
	value as DonateInfo.public;


mapping donates:
	key as field.public;
	value as u64.public;

function create_donate:
    input r0 as DonateInfo.private;
    hash.bhp256 r0.title into r1 as field;
    cast self.caller r1 into r2 as DonateEvent.record;
    async create_donate self.caller r1 into r3;
    output r2 as DonateEvent.record;
    output r3 as donates.aleo/create_donate.future;

finalize create_donate:
    input r0 as address.public;
    input r1 as field.public;
    get.or_use donates[r1] 0u64 into r2;
    set r2 into donates[r1];


function make_donate:
    input r0 as MakeDonateInfo.private;
    cast r0.amount r0.id into r1 as MakeDonateInfo;
    async make_donate r0 into r2;
    output r1 as MakeDonateInfo.private;
    output r2 as donates.aleo/make_donate.future;

finalize make_donate:
    input r0 as MakeDonateInfo.public;
    get donates[r0.id] into r1;
    add r1 r0.amount into r2;
    set r2 into donates[r0.id];
