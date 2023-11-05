program donates.aleo {

  struct DonateInfo {
    title: field;
  }

  struct MakeDonateInfo {
    amount: u64;
    id: field;
  }

  record DonateEvent {
    owner: address;
    id: field
  }

  record Donate {
    gates: u64;
    owner: address;
    info: MakeDonateInfo;
  }

  mapping fieldInfo: field => DonateInfo;
  mapping donates: field => u64;

  transition create_donate (info: DonateInfo) -> DonateEvent {
    let id: field = BHP256::hash_to_field(info.title);
    return DonateEvent {
      id: id,
      owner: self.caller
    } then finalize(self.caller, id);
  }

  finalize create_donate (owner: address, id: field) {
    let amount: u64 = Mapping::get_or_use(donates, id, 0u64);
    Mapping::set(donates, id, amount);
  }

  transition make_donate(makeDonateInfo: MakeDonateInfo) -> MakeDonateInfo {
    return MakeDonateInfo {
      amount: makeDonateInfo.amount,
      id: makeDonateInfo.id
    } then finalize(makeDonateInfo);
  }

  finalize make_donate (makeDonateInfo: MakeDonateInfo) {
    let amount: u64 = Mapping::get(donates, makeDonateInfo.id);
    Mapping::set(donates, makeDonateInfo.id, amount.add(makeDonateInfo.amount));
  }
}
