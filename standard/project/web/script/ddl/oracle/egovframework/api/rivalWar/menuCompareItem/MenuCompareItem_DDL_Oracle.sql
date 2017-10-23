/*
 * JsTree 추적 로그 테이블
 * 트리거 Log를 저장합니다.
 */
CREATE TABLE T_M_MENU_COMPAREITEM_LOG
(
 C_ID        NUMBER                            NOT NULL,
 C_PARENTID  NUMBER                            NOT NULL,
 C_POSITION  NUMBER                            NOT NULL,
 C_LEFT      NUMBER                            NOT NULL,
 C_RIGHT     NUMBER                            NOT NULL,
 C_LEVEL     NUMBER                            NOT NULL,
 C_TITLE     VARCHAR2(4000 BYTE),
 C_TYPE      VARCHAR2(4000 BYTE),
 C_METHOD    VARCHAR2(4000 BYTE),
 C_STATE     VARCHAR2(4000 BYTE),
 C_DATE      DATE                              NOT NULL
);

COMMENT ON TABLE T_M_MENU_COMPAREITEM_LOG IS '기본 트리 스키마 트리거 로그';
COMMENT ON COLUMN T_M_MENU_COMPAREITEM_LOG.C_ID IS '노드 아이디';
COMMENT ON COLUMN T_M_MENU_COMPAREITEM_LOG.C_PARENTID IS '부모 노드 아이디';
COMMENT ON COLUMN T_M_MENU_COMPAREITEM_LOG.C_POSITION IS '노드 포지션';
COMMENT ON COLUMN T_M_MENU_COMPAREITEM_LOG.C_LEFT IS '노드 좌측 끝 포인트';
COMMENT ON COLUMN T_M_MENU_COMPAREITEM_LOG.C_RIGHT IS '노드 우측 끝 포인트';
COMMENT ON COLUMN T_M_MENU_COMPAREITEM_LOG.C_LEVEL IS '노드 DEPTH ';
COMMENT ON COLUMN T_M_MENU_COMPAREITEM_LOG.C_TITLE IS '노드 명';
COMMENT ON COLUMN T_M_MENU_COMPAREITEM_LOG.C_TYPE IS '노드 타입';
COMMENT ON COLUMN T_M_MENU_COMPAREITEM_LOG.C_METHOD IS '노드 변경 행위';
COMMENT ON COLUMN T_M_MENU_COMPAREITEM_LOG.C_STATE IS '노드 상태값 ( 이전인지. 이후인지)';
COMMENT ON COLUMN T_M_MENU_COMPAREITEM_LOG.C_DATE IS '노드 변경 시';

/*
 * JsTree
 */
CREATE TABLE T_M_MENU_COMPAREITEM
(
 C_ID        		NUMBER                            NOT NULL,
 C_PARENTID  	    NUMBER                            NOT NULL,
 C_POSITION  	    NUMBER                            NOT NULL,
 C_LEFT      		NUMBER                            NOT NULL,
 C_RIGHT     		NUMBER                            NOT NULL,
 C_LEVEL     		NUMBER                            NOT NULL,
 C_TITLE     		VARCHAR2(4000 BYTE),
 C_TYPE      		VARCHAR2(4000 BYTE),

    MAPPING_MENU_ID     NUMBER,
    COMPARE_ITEM_NAME   VARCHAR2(4000 BYTE),

 CONSTRAINT  T_M_MENU_COMPAREITEM_PK PRIMARY KEY (C_ID)
 /*
   * CONSTRAINT  T_M_MENU_COMPAREITEM_FK1 FOREIGN KEY (OTHER_ID) REFERENCES OTHER T_M_MENU_COMPAREITEM(C_ID) ON DELETE CASCADE
   */
);

COMMENT ON TABLE T_M_MENU_COMPAREITEM IS '기본 트리 스키마';
COMMENT ON COLUMN T_M_MENU_COMPAREITEM.C_ID IS '노드 아이디';
COMMENT ON COLUMN T_M_MENU_COMPAREITEM.C_PARENTID IS '부모 노드 아이디';
COMMENT ON COLUMN T_M_MENU_COMPAREITEM.C_POSITION IS '노드 포지션';
COMMENT ON COLUMN T_M_MENU_COMPAREITEM.C_LEFT IS '노드 좌측 끝 포인트';
COMMENT ON COLUMN T_M_MENU_COMPAREITEM.C_RIGHT IS '노드 우측 끝 포인트';
COMMENT ON COLUMN T_M_MENU_COMPAREITEM.C_LEVEL IS '노드 DEPTH ';
COMMENT ON COLUMN T_M_MENU_COMPAREITEM.C_TITLE IS '노드 명';
COMMENT ON COLUMN T_M_MENU_COMPAREITEM.C_TYPE IS '노드 타입';

COMMENT ON COLUMN T_M_MENU_COMPAREITEM.MAPPING_MENU_ID IS '맵핑할 메뉴의 아이디';
COMMENT ON COLUMN T_M_MENU_COMPAREITEM.COMPARE_ITEM_NAME IS '비교 하위 아이템 이름';

/*
 * 인덱스는 되도록 걸지 말것.
 * CREATE UNIQUE INDEX I_COMPREHENSIVETREE ON T_M_MENU_COMPAREITEM
 *      ("C_ID" ASC)
 * DROP SEQUENCE S_M_MENU_COMPAREITEM;
 */


CREATE SEQUENCE S_M_MENU_COMPAREITEM
 START WITH 10
 MAXVALUE 999999999999999999999999999
 MINVALUE 0
 NOCYCLE
 CACHE 20
 NOORDER;

/*
 * JsTree 트리거
 */
CREATE OR REPLACE TRIGGER "TG_M_MENU_COMPAREITEM"
BEFORE DELETE OR INSERT OR UPDATE
ON T_M_MENU_COMPAREITEM
REFERENCING NEW AS NEW OLD AS OLD
FOR EACH ROW
DECLARE
tmpVar NUMBER;
/******************************************************************************
   NAME:       TRIGGER_COMPREHENSIVETREE
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        2012-08-29             1. Created this trigger.

   NOTES:

   Automatically available Auto Replace Keywords:
      Object Name:     TRIGGER_COMPREHENSIVETREE
      Sysdate:         2012-08-29
      Date and Time:   2012-08-29, 오후 5:26:44, and 2012-08-29 오후 5:26:44
      Username:         (set in TOAD Options, Proc Templates)
      Table Name:      T_M_MENU_COMPAREITEM (set in the "New PL/SQL Object" dialog)
      Trigger Options:  (set in the "New PL/SQL Object" dialog)
******************************************************************************/
BEGIN
  tmpVar := 0;
   IF UPDATING  THEN
       insert into T_M_MENU_COMPAREITEM_LOG
       values (:old.C_ID,:old.C_PARENTID,:old.C_POSITION,:old.C_LEFT,:old.C_RIGHT,:old.C_LEVEL,:old.C_TITLE,:old.C_TYPE,'update','변경이전데이터',sysdate);
       insert into T_M_MENU_COMPAREITEM_LOG
       values (:new.C_ID,:new.C_PARENTID,:new.C_POSITION,:new.C_LEFT,:new.C_RIGHT,:new.C_LEVEL,:new.C_TITLE,:new.C_TYPE,'update','변경이후데이터',sysdate);
    END IF;
   IF DELETING THEN
       insert into T_M_MENU_COMPAREITEM_LOG
       values (:old.C_ID,:old.C_PARENTID,:old.C_POSITION,:old.C_LEFT,:old.C_RIGHT,:old.C_LEVEL,:old.C_TITLE,:old.C_TYPE,'delete','삭제된데이터',sysdate);
   END IF;
   IF INSERTING  THEN
       insert into T_M_MENU_COMPAREITEM_LOG
       values (:new.C_ID,:new.C_PARENTID,:new.C_POSITION,:new.C_LEFT,:new.C_RIGHT,:new.C_LEVEL,:new.C_TITLE,:new.C_TYPE,'insert','삽입된데이터',sysdate);
   END IF;

  EXCEPTION
    WHEN OTHERS THEN
      -- Consider logging the error and then re-raise
      RAISE;
END TG_M_MENU_COMPAREITEM;


/