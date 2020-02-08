
`etc/known_hosts`
最初にprivate repositoryをgit cloneするときのためだけの `.ssh/known_hosts`。
git cloneが終わったら `.ssh/known_hosts` は削除され、それ以降は
private repositoryにある `.ssh/known_hosts` が使用される。

