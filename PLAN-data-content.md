# data.incensehub.org — 内容规划（与主站互补，不重复）

> 版本：2026-11-04
> 主站仓库：`/root/.openclaw/workspace/repos/incensehub.org`
> 数据站仓库：`incensehubdata`
> 目标：把数据站做成“结构化事实 + 关系图 + 可下载数据”的参考层，主站继续做“叙事、指南、配方、历史、安全”的内容层。

---

## 1. 现状盘点

### 1.1 主站（incensehub.org）
- 266 个内容页：150 个原料页、115 篇 blog、1 个概念页、14 个其他页面
- 150 个原料页已有 canonical URL、来源、FAQ、内链
- `data/*.json` 有 8 个数据集镜像（ingredients / terminology / relationships / comparisons / materials / forms / techniques / aroma）
- `/data/*` 有 4 条 301，指向 `data.incensehub.org`

### 1.2 数据站（IncenseHub Data）
- MkDocs 静态站，8 个数据集：
  - ingredients 150
  - terminology 249
  - relationships 150 条记录 / 806 条 typed edges
  - comparisons 17
  - materials 15
  - techniques 12
  - forms 12
  - aroma 10
- 已生成 **205 个实体页**（`docs/entities/`，同一 termCode 跨数据集合并）
- 已有：实体级 `DefinedTerm` JSON-LD、claim/evidence 表、Evidence Tier 1–6、CC BY-SA 4.0、CSV 下载、JSON 端点、CI 校验
- 已有文档：datasets 总览、每数据集字段说明、format & governance、entity index、relationships 说明
- 构建：`mkdocs build`，hooks 在构建时注入计数、生成实体页、复制 JSON、导出 CSV

### 1.3 关键问题（按优先级）
1. **域名身份错位**：`data.incensehub.org` 当前 **NXDOMAIN**；实际在线的是 `data.incensehub.org`（200）
2. **主站 301 指向死域名**：`/data/*` → `data.incensehub.org`，用户点击会 DNS 失败
3. **数据站仍用旧品牌**：`mkdocs.yml` 的 `site_url`、生成器 `SITE_URL`、224 个文件里的链接都指向 `data.incensehub.org` / `incensehub.org`；0 个文件引用 `incensehub.org`
4. **实体 JSON-LD 的 `mainEntityOfPage` 指向旧主站** `incensehub.org`，与真实主站 `incensehub.org` 不一致
5. **重复风险**：205 个实体页与主站 150 个原料页都在解释同一批原料；如果不分工，会形成站内竞争
6. **数据站还有未 surface 的资产**：249 条术语只有锚点索引、17 个对比没有独立页、relationships 只有表格没有浏览页

---

## 2. 定位：两层，不是两个内容站

| 层 | 站点 | 职责 | 读者 |
|---|---|---|---|
| 内容层 | `incensehub.org` | 长文、指南、历史、配方、安全、采购判断 | 普通读者、爱好者、买家 |
| 数据层 | `data.incensehub.org` | 结构化记录、关系图、证据等级、下载、API | 研究者、开发者、AI、深度读者 |

一句话：**主站回答“为什么/怎么用”，数据站回答“是什么/和谁有关/证据在哪”。**

---

## 3. 互补规则（硬约束）

### 主站做
- 2,000–8,000 词的叙事文章
- 历史、文化、配方、安全、采购、对比的“判断”
- 每篇原料文章保留：直接回答、关键事实、用法、风险、FAQ、来源

### 数据站做
- 150–400 词的实体记录：定义、属性、关系、证据、canonical ID
- 数据集文档：字段、类型、示例、版本、许可、下载
- 关系浏览：type / entity / inverse edge
- 对比数据页：结构化表格 + “数据说明了什么”短评
- 术语表：拼音、字面义、英文译名、语境、来源
- 下载 / API / JSON Schema / changelog

### 双方都不做
- 数据站不写长文指南、配方、安全长文
- 主站不复制完整数据集表格/JSON；只放摘要并链接到数据站
- 不出现两个 canonical 解释同一实体
- 不为了页数把 249 个术语全部做成薄页；没有 3 个以上字段的术语留在索引里

### 互链规则
- 数据实体页 `mainEntityOfPage` → 主站对应文章
- 主站原料页 `sameAs` → 数据实体 `#entity`
- 统一用 `termCode` 作为跨站 ID
- 每个实体页底部固定：“Read the full guide on IncenseHub”

---

## 4. 数据站信息架构

```
/                                  数据集门户：8 个数据集、205 实体、806 边、版本、许可、搜索
/datasets/                         数据集总览
/datasets/{name}/                  单数据集文档：字段、类型、示例、JSON/CSV、changelog、license
/entities/                         实体索引（按字母/类型）
/entities/{termCode}/              205 个实体页：定义、属性、关系、证据、主站链接
/terms/                            术语表索引（249）
/terms/{termCode}/                 术语页（仅当字段足够；否则留在索引）
/relationships/                    关系浏览：按类型、按实体、反向边
/comparisons/                      17 个对比档案
/comparisons/{termCode}/           结构化对比表 + 数据短评
/downloads/                        JSON / CSV 打包下载
/api/                              静态 JSON 端点说明 + 示例
/schemas/                          JSON Schema（每个数据集）
/changelog/                        版本与变更记录
/license/                          CC BY-SA 4.0 + 引用格式
/methodology/                      证据分级、来源范围、编辑规则
/search/                           站内搜索（MkDocs search 或 Pagefind）
/llms.txt                          AI 入口：数据集、计数、端点、实体索引
```

### 页面模板

**数据集页**
1. 一句话定义
2. 计数 / 版本 / dateModified
3. 字段表（字段、类型、必填、说明）
4. 2–3 个 JSON 示例
5. JSON / CSV 下载
6. changelog
7. license + 引用格式
8. 相关实体/主站文章

**实体页**
1. 名称（中英）+ termCode
2. 1–2 句定义
3. Attributes 表
4. Relationships 表（含反向边）
5. Claim & Evidence（沿用现有）
6. 主站文章链接
7. JSON-LD DefinedTerm
8. 最后更新 / 数据集版本

**术语页**
1. 中文 / 拼音 / 字面义 / 英文译名
2. 语境（1–2 句）
3. 常见误译
4. 来源 / 证据等级
5. 关联实体
6. 主站相关文章

**对比页**
1. 结论先行（数据支持什么）
2. 对比表（从 comparisons.json 投影）
3. 适用场景
4. 数据缺口 / 不确定性
5. 主站叙事对比链接

---

## 5. 内容缺口与优先级

### P0（先修，否则内容越多越浪费）
1. **域名统一**：`data.incensehub.org` 解析到数据站；旧 `data.incensehub.org` 301 到新域名
2. **全站替换旧域名**：`mkdocs.yml` 的 `site_url`、`scripts/generate-entity-pages.py` 的 `SITE_URL`、`docs/**` 链接、CI allow-list、`mainEntityOfPage`
3. **主站 `/data/*` 301 验证**：确保指向可解析的新域名
4. **品牌统一**：IncenseHub Data → IncenseHub Data；主站链接改为 `incensehub.org`

### P1（数据站的核心增量）
5. **249 条术语**：当前只有锚点索引；为字段足够的术语生成独立页，其余保留索引
6. **关系浏览**：按 type（category/aroma/related/technique/comparison）和 entity 浏览；补反向边
7. **17 个对比页**：结构化表格 + 短评，链接主站叙事对比
8. **数据集页补 Dataset JSON-LD**：`Dataset` + `DefinedTerm` + `license` + `version`
9. **搜索**：MkDocs search 或 Pagefind；至少覆盖实体/术语/数据集
10. **llms.txt + markdown**：数据集清单、端点、实体索引；静态 md 变体

### P2（增强）
11. **JSON Schema**：每个数据集一份，CI 校验
12. **版本/release 页**：`/changelog/`，按 version + dateModified
13. **数据短评**：6–10 篇，例如“150 个原料的 aroma family 分布”“806 条关系里最常见的 10 个节点”，每篇 400–700 词，链主站
14. **引用格式**：BibTeX / APA / Chicago，方便研究者引用

---

## 6. SEO / AIO

### 结构化数据
- 数据集页：`Dataset`（name、description、license、version、dateModified、distribution）
- 实体页：`DefinedTerm`（已有，修域名）
- 术语页：`DefinedTerm`
- 对比页：`ItemList` 或 `Table`
- 全站：`Organization`、`WebSite`、`BreadcrumbList`

### 索引策略
- 205 个实体页：index, follow
- 249 个术语：字段足够的 index；否则留在索引页，不单独收录
- 数据集页：index
- 下载/API/schema：index
- 旧域名：301，不保留 index

### AIO
- `llms.txt`：8 个数据集 + 205 实体 + 249 术语 + 端点 + 许可
- `llms-full.txt`：可选，列出全部 termCode 与一句话定义
- 每个实体页 answer-first；JSON-LD 可解析
- 静态 JSON 端点稳定、带 version/dateModified
- 不在数据站写“观点长文”；观点留在主站

### 内链
- 数据集页 → 实体页 → 主站文章
- 实体页 → 数据集页 / 关系页 / 对比页
- 主站原料页 → 数据实体（`sameAs`）
- 主站 blog → 相关数据实体/术语（只链一次，不重复解释）

---

## 7. 技术方案

### 保留 MkDocs
- 继续用 `hooks.py`：计数注入、实体页生成、JSON 复制、CSV 导出
- 新增：
  - `scripts/generate-term-pages.py`（249 术语，按字段阈值生成）
  - `scripts/generate-relationship-pages.py`（按 type/entity）
  - `scripts/generate-dataset-pages.py`（如果当前是手写，改为投影）
  - `scripts/export_json_schema.py`
- 配置：
  - `mkdocs.yml`：`site_url: https://data.incensehub.org`，补 `nav`，启用 search
  - 新增 `docs/llms.txt`、`docs/_headers`、`docs/_redirects`（或 Cloudflare 配置）
- CI：
  - 现有 `validate.yml` 更新 allow-list 域名
  - 增加：canonical 域名检查、termCode 唯一性、实体页数量、0 broken internal links

### 数据流
```
datasets/*.json  (single source of truth)
  → validate (CI)
  → generate entity/term/relationship/comparison pages
  → mkdocs build
  → site/ (JSON + CSV + HTML)
  → deploy (Cloudflare Pages / GitHub Pages)
```

### 域名
- `data.incensehub.org` CNAME → 部署目标
- `data.incensehub.org` 301 → `data.incensehub.org`（如果旧域名仍在使用）
- 主站 `/data/*` 301 保留，指向新域名

---

## 8. 14 天执行计划

**Day 1–2：身份与域名**
- 修 `mkdocs.yml` / `SITE_URL` / 224 处旧域名引用
- 配 DNS、验证 `data.incensehub.org` 200
- 主站 `/data/*` 301 复测
- 旧域名 301

**Day 3–5：数据集层**
- 8 个数据集页补字段表、示例、JSON/CSV、changelog、license
- Dataset JSON-LD
- `/downloads/`、`/api/`、`/schemas/` 初版
- `llms.txt`

**Day 6–8：实体与术语**
- 205 实体页复核：定义、属性、关系、证据、主站链接
- 249 术语：字段足够的生成独立页；其余留索引
- 实体/术语搜索

**Day 9–10：关系与对比**
- `/relationships/` 按 type/entity 浏览；补反向边
- 17 个对比页
- 主站 ↔ 数据站互链审计

**Day 11–12：SEO/AIO/QA**
- canonical、JSON-LD、sitemap 分块、robots、llms、markdown
- 断链、重复、薄页检查
- CI 校验

**Day 13–14：上线**
- 部署、DNS 切换、旧域名 301
- GSC 提交 sitemap
- 首日监控 + 修复

---

## 9. 验收指标

- 8 个数据集页全部有 schema/字段/下载/changelog
- 205 个实体页 100% 有 canonical + JSON-LD + 主站链接
- 249 个术语：≥60% 有独立页，其余在索引可检索
- 17 个对比页全部上线
- 806 条关系可按 type/entity 浏览
- 0 broken internal links；0 旧域名引用
- `data.incensehub.org` 200；`/data/*` 301 正常
- 主站 → 数据站 referrals 可追踪（UTM 或 GSC）
- 数据集下载/引用可统计

---

## 10. 风险

1. **域名迁移**：旧域名仍有流量/外链，必须 301，不能直接弃用
2. **重复内容**：205 实体页与 150 主站原料页最容易撞；必须坚持“数据站短记录 + 主站长文”的分工
3. **薄页**：249 术语不要全部生成；没有 3 个以上字段的留在索引
4. **数据过期**：`dateModified`/version 必须真实；不能伪造“刚更新”
5. **主站 301 死链**：当前 `/data/*` 指向 NXDOMAIN，是最高优先级的修复项
6. **CI allow-list**：换域名后旧 allow-list 会拦住构建，必须先更新

---

## 11. 结论

数据站不是“第二个主站”，而是主站的**结构化底座**：
- 主站继续做内容与判断
- 数据站做实体、关系、证据、下载
- 两边用 `termCode` 和 `sameAs` 互链，不重复解释

先修域名与 canonical，再补数据集页与术语页，最后做关系/对比/搜索。这样数据站既能被 Google 收录，也能被 AI 直接读取，而不会和主站互相竞争。
